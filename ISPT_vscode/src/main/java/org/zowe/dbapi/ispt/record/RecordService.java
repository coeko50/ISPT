/*
 * This program and the accompanying materials are made available and may be used, at your option, under either:
 * Eclipse Public License v2.0, available at https://www.eclipse.org/legal/epl-v20.html, OR
 * Apache License, version 2.0, available at http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: EPL-2.0 OR Apache-2.0
 *
 * Copyright Contributors to the Zowe Project.
 */
package org.zowe.dbapi.ispt.record;

import java.math.*; // for data types
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import lombok.extern.slf4j.Slf4j;

import org.apache.coyote.BadRequestException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.zowe.dbapi.ispt.mapfields.Mapfields;
import org.zowe.dbapi.ispt.mapfields.MapfieldsService;
import org.zowe.dbapi.ispt.record.Record;
import org.zowe.dbapi.utilities.GenJsonSchema;
import org.zowe.dbapi.utilities.JsonSchema;

import com.broadcom.dbapi.common.DataSourceRouter;
import com.broadcom.dbapi.exception.DataSourceNotFoundException;
import com.broadcom.dbapi.exception.ResourceNotFoundException;
import java.io.*;
import java.net.*;

/**
 * Implements SQL access for the ISPT RECORD view
 *
 * @author Zowe Database API Generator
 * @since 1.0
 */
@Service("IsptRecordService")
@Slf4j
public class RecordService {

    static final int port = 40115;
    static final String url = "192.168.24.227";

    static final String maprec_SELECT = "SELECT distinct rec,recver from ispt.maprecords ";

    static final String SQL_SELECT = "SELECT " +
            " JSONREC,JRECVER,JSONFLD,REC,RECVER,ELE,SEQ,LVL,ISGRP,POS," +
            " DTYPE,MODE,LEN,DLEN,PREC,SCALE,OCC,OCCDEPEND,OCCLVL,REDEFLVL,REDEFELE,DESC,PREFIX " +

            " FROM \"ISPT\".\"RECORD_INFO\" ";

    static final String SQL_WHERE_PKEYS = "WHERE rec = ?  and recver = ?";
    @Autowired
    private DataSourceRouter dataSourceRouter;
    JsonSchema jsch;

    /**
     * jsonSchema4mapRecords
     * 
     * SELECT a result set from the RECORD view
     * 
     * @return Record array containing the contents of the result set
     */
    public List<String> jsonSchema4mapRecords(String datasource,String loadmod,String mapName, Short mapver, String path)
            throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
        log.debug("RecordService.jsonSchema4mapRecords query({} {} {}", datasource, mapName, mapver);
          List<String> bodyParm = new ArrayList<String>();
        String[] mapNames = mapName.split(",");

  
        String schema = loadmod;

        String whereClause = " where map in (%s) and mapver = %d";
        String mapWhere = whereClause.replaceFirst("%s", buildMapList(mapNames));
        mapWhere = mapWhere.replaceFirst("%d", String.valueOf(mapver));
        log.debug("map where: {}", mapWhere);

        File mpath = FileSystems.getDefault().getPath("src/main/java/org/zowe/dbapi/" + path).toAbsolutePath().toFile();
        mpath.mkdirs();
        String currentDirectoryPath = mpath.toString();

        log.debug("Current path is:{}:  fs", currentDirectoryPath);

        Connection conn;
        List<Record> array = new ArrayList<Record>();
        conn = dataSourceRouter.getConnection(datasource);
        try (PreparedStatement stmt = conn.prepareStatement(maprec_SELECT + mapWhere);) {

            try (ResultSet rs = stmt.executeQuery();) {
                while (rs.next()) {
                    String recname = (((String) rs.getObject("REC")).trim());
                    Short recver = ((Short) rs.getObject("RECVER"));
                    log.debug("maprecord {} {}", recname, recver);
                    array.addAll(recQuery(conn, recname, recver));
                }
            }
        }
        if (array.size() == 0) {
            throw new ResourceNotFoundException(
                    "Map " + mapName + " version " + mapver + " has no records, strange as it may sound");
        }
        log.debug("record ele retrieved {}", array.size());
        GenJsonSchema gjs = new GenJsonSchema();
        jsch = gjs.buildSchema(schema, mapver, array);
        log.debug("JsonSchema build, {} elements", jsch.countElements());
        // List<String> json = gjs.genSchema(jsch);
        MapfieldsService mfldService = new MapfieldsService();
        List<Mapfields> mapfields = mfldService.query(conn, mapWhere);
        conn.close();
        log.debug("{} mapfields retrieved ", mapfields.size());
        gjs.updateSchemaWithMapInfo(jsch, mapfields);

        File schFile = new File(currentDirectoryPath + "/" + jsch.getName() + ".json");

        List<String> jsonSch = gjs.genSchema(jsch);
        GenJsonSchema.writeFile(jsonSch, schFile);
        for (String l : jsonSch) {
            gjs.print(l);
        }

        jsonSch = gjs.genRecEleSelectList(jsch);
        GenJsonSchema.writeFile(jsonSch,
                new File(currentDirectoryPath + "/" + jsch.getName() + "_recordSelection.json"));
        for (String l : jsonSch) {
            gjs.print(l);
        }
        
        bodyParm = gjs.genJsonLoadModule(jsch);
        log.debug("RecordService.generateJsonSchema bodyparms rows {} little bit {}", bodyParm.size(), bodyParm.get(1));
        for (String l : jsonSch) {
            gjs.print(l);
        }
        String res;
        log.debug("RecordService.generateJsonSchema about to store ");
 
        try {
            res = gjs.postLoadMod(datasource, bodyParm);
        } catch (BadRequestException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return jsonSch;
    }

    /*
     * GenerateJsonSchema
     */
    public List<String> generateJsonSchema(String datasource, String schema, String path, String mappingFile)
            throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
        List<String> jsonSch = new ArrayList<String>();
        List<String> bodyParm = new ArrayList<String>();
        GenJsonSchema gjs = new GenJsonSchema();
        log.debug("RecordService.generateJsonSchema query({} {} {}", datasource, path, mappingFile);
        bodyParm = gjs.genJsonLoadModule(jsch);
        log.debug("RecordService.generateJsonSchema bodyparms rows {} little bit {}", bodyParm.size(), bodyParm.get(1));
        for (String l : jsonSch) {
            gjs.print(l);
        }
        String res;
        log.debug("RecordService.generateJsonSchema about to store ");
 //postLoadMod(String datasource, List<String> loadmod)
        try {
            res = gjs.postLoadMod(datasource, bodyParm);
        } catch (BadRequestException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return jsonSch;

    }

    public String buildMapWhereClausex(String[] mapNames, Short mapver) {
        String where = " where map ";

        if (mapNames.length > 1) {
            where += "in (";
            String cont = "";

            for (String name : mapNames) {
                where += cont + "'" + name.trim().toUpperCase() + "'";
                cont = ",";
            }
            where += ")";
        } else {
            where += "= '" + mapNames[0].trim() + "'";
        }
        where += " and mapver =" + mapver;
        return where;

    }

    public String buildMapList(String[] mapNames) {
        String mapList = "";
        String cont = "";

        for (String name : mapNames) {
            mapList += cont + "'" + name.trim() + "'";
            cont = ",";
        }
        return mapList;
    }

    public List<Record> recQuery(Connection conn, String rec, Short recver)
            throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
        log.debug("RecordService.recQuery({} {} {})", "conn", rec, recver);

        List<Record> array = new ArrayList<Record>();
        // conn = dataSourceRouter.getConnection(datasource);
        try (PreparedStatement stmt = conn.prepareStatement(SQL_SELECT + SQL_WHERE_PKEYS);) {

            stmt.setString(1, rec);
            stmt.setShort(2, recver);
            try (ResultSet rs = stmt.executeQuery();) {
                while (rs.next()) {
                    Record record = new Record();
                    record
                            .setJsonRec(((String) rs.getObject("JSONREC")).trim())
                            .setJrecVer((Short) rs.getObject("JRECVER"))
                            .setJsonfld(((String) rs.getObject("JSONFLD")).trim())
                            .setRec(((String) rs.getObject("REC")).trim())
                            .setRecVer((Short) rs.getObject("RECVER"))
                            .setEle(((String) rs.getObject("ELE")).trim())
                            .setSeq((Integer) rs.getObject("SEQ"))
                            .setLvl((Short) rs.getObject("LVL"))
                            .setIsGrp(((String) rs.getObject("ISGRP")).trim())
                            .setPos((Short) rs.getObject("POS"))
                            .setDtype((Short) rs.getObject("DTYPE"))
                            .setMode((Short) rs.getObject("MODE"))
                            .setLen((Short) rs.getObject("LEN"))
                            .setDlen((Short) rs.getObject("DLEN"))
                            .setPrec((Short) rs.getObject("PREC"))
                            .setScale((Short) rs.getObject("SCALE"))
                            .setOcc((Short) rs.getObject("OCC"))
                            .setOccLvl((Short) rs.getObject("OCCLVL"))
                            .setOccDependEle((String) rs.getObject("OCCDEPEND"))
                            .setRedefLvl((Short) rs.getObject("REDEFLVL"))
                            .setRedefEle(((Integer) rs.getObject("REDEFELE")))
                            .setDesc(((String) rs.getObject("DESC")).trim())
                            .setPrefix(((String) rs.getObject("PREFIX")).trim());
                    array.add(record);

                }
            }
        }
        return array;
    }

   
}
