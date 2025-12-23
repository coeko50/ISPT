/*
 * This program and the accompanying materials are made available and may be used, at your option, under either:
 * Eclipse Public License v2.0, available at https://www.eclipse.org/legal/epl-v20.html, OR
 * Apache License, version 2.0, available at http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: EPL-2.0 OR Apache-2.0
 *
 * Copyright Contributors to the Zowe Project.
 */
package org.zowe.dbapi.ispt.mapfields;

import java.math.*;    // for data types
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.broadcom.dbapi.common.DataSourceRouter;
import com.broadcom.dbapi.exception.DataSourceNotFoundException;
import com.broadcom.dbapi.exception.ResourceNotFoundException;

/**
 * Implements SQL access for the SQL MAPFIELDS view
 *
 * @author Zowe Database API Generator
 * @since 1.0
 */
@Service("IsptMapfieldsService")
@Slf4j
public class MapfieldsService {

    static final String SQL_SELECT = "SELECT " +
        "\"REC\", \"RECVER\", \"ELE\", \"UPDATEABLE\", \"REQUIRED\", \"SEQ\", \"LVL\", \"PIC\", \"MAP\" " +
        "FROM \"ISPT\".\"MAPFIELDS\" ";

    static final String SQL_SELECT_PKEYS = "SELECT " +
        "\"MAP\" " +
        "FROM \"ISPT\".\"MAPFIELDS\" ";

    static final String SQL_WHERE_PKEYS = "WHERE \"MAP\" in (?)  and mapver = ?";

    static final String SQL_WHERE_QKEYS = "WHERE \"MAP\" = ?";

    @Autowired
    private DataSourceRouter dataSourceRouter;

    /**
     * SELECT the primary or selected key and description columns from the MAPFIELDS view
     * @param map MAP value
     * @return MapfieldsKeys array containing the primary or selected keys for the table or view
     */
    public List<MapfieldsKeys> keys(String datasource)
        throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
        log.debug("MapfieldsKeysService.keys()");

        List<MapfieldsKeys> array = new ArrayList<MapfieldsKeys>();
        try(Connection conn = dataSourceRouter.getConnection(datasource);
            PreparedStatement stmt = conn.prepareStatement(SQL_SELECT_PKEYS);
            ResultSet rs = stmt.executeQuery();) {
            while (rs.next()) {
                MapfieldsKeys mapfieldskeys = new MapfieldsKeys();
                mapfieldskeys
                .setMap((String)rs.getObject("MAP"));
                array.add(mapfieldskeys);
            }
        }
        return array;
    }

    /**
     * SELECT exactly one row from the MAPFIELDS view
     * @param map MAP value
     * @return Mapfields object containing the contents of the data base record
     */
    public Mapfields get(String datasource, String map)
        throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
        log.debug("MapfieldsService.select({}, {})", datasource, map);

        Mapfields mapfields = new Mapfields();
        try(Connection conn = dataSourceRouter.getConnection(datasource);
            PreparedStatement stmt = conn.prepareStatement(SQL_SELECT + SQL_WHERE_PKEYS);) {
            stmt.setString(1, map);
            try(ResultSet rs = stmt.executeQuery();) {
                if (rs.next()) {
                    mapfields
                    .setRec((String)rs.getObject("REC"))
                    .setRecver((Short)rs.getObject("RECVER"))
                    .setEle((String)rs.getObject("ELE"))
                    .setUpdateable((String)rs.getObject("UPDATEABLE"))
                    .setRequired((String)rs.getObject("REQUIRED"))
                    .setSeq(((BigDecimal)rs.getObject("SEQ")).intValue())
                    .setLvl(((BigDecimal)rs.getObject("LVL")).shortValue())
                    .setPic((String)rs.getObject("PIC"))
                    .setMap((String)rs.getObject("MAP"));
                } else {
                    throw new ResourceNotFoundException("MAPFIELDS");
                }
            }
        }
        return mapfields;
    }

    /**
     * SELECT a result set from the MAPFIELDS view
     * @param map MAP value
     * @return Mapfields array containing the contents of the result set
     */
    public List<Mapfields> query(String datasource, String map, Short mapver)
        throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
        log.debug("MapfieldsService.query({}, {} {})", datasource, map,mapver);

        List<Mapfields> array = new ArrayList<Mapfields>();
        try(Connection conn = dataSourceRouter.getConnection(datasource);
            PreparedStatement stmt = conn.prepareStatement(SQL_SELECT + SQL_WHERE_PKEYS);) {
            stmt.setString(1, map);
            stmt.setShort(2, mapver);
            try(ResultSet rs = stmt.executeQuery();) {
                while (rs.next()) {
                    Mapfields mapfields = new Mapfields();
                    mapfields
                    .setRec((String)rs.getObject("REC"))
                    .setRecver((Short)rs.getObject("RECVER"))
                    .setEle((String)rs.getObject("ELE"))
                    .setUpdateable((String)rs.getObject("UPDATEABLE"))
                    .setRequired((String)rs.getObject("REQUIRED"))
                     .setSeq(((BigDecimal)rs.getObject("SEQ")).intValue())
                    .setLvl(((BigDecimal)rs.getObject("LVL")).shortValue())
                    .setPic((String)rs.getObject("PIC"))
                    .setMap((String)rs.getObject("MAP"));
                    array.add(mapfields);
                }
            }
        }
        return array;
    }
    public List<Mapfields> query(Connection conn, String mapWhere)
    throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
    log.debug("MapfieldsService.query({}, {} )", conn.getClientInfo(), mapWhere);

    List<Mapfields> array = new ArrayList<Mapfields>();
   // try(Connection conn = dataSourceRouter.getConnection(datasource);
     try (   PreparedStatement stmt = conn.prepareStatement(SQL_SELECT + mapWhere );) {
    
        try(ResultSet rs = stmt.executeQuery();) {
            while (rs.next()) {
                Mapfields mapfields = new Mapfields();
                mapfields
                .setRec(((String)rs.getObject("REC")).trim())
                .setRecver((Short)rs.getObject("RECVER"))
                .setEle(((String)rs.getObject("ELE")).trim())
                .setUpdateable((String)rs.getObject("UPDATEABLE"))
                .setRequired((String)rs.getObject("REQUIRED"))
                .setSeq(((BigDecimal)rs.getObject("SEQ")).intValue())
                .setLvl(((BigDecimal)rs.getObject("LVL")).shortValue())
                .setPic(((String)rs.getObject("PIC")).trim())
                .setMap(((String)rs.getObject("MAP")).trim());
                array.add(mapfields);
            }
        }
    }
    return array;
}
}
