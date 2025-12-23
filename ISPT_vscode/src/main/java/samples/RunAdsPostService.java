package  samples;

/*
* This program and the accompanying materials are made available and may be used, at your option, under either:
* Eclipse Public License v2.0, available at https://www.eclipse.org/legal/epl-v20.html, OR
* Apache License, version 2.0, available at http://www.apache.org/licenses/LICENSE-2.0
*
* SPDX-License-Identifier: EPL-2.0 OR Apache-2.0
*
* Copyright Contributors to the Zowe Project.
*/

import java.math.*; // for data types
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import lombok.extern.slf4j.Slf4j;

import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
// import org.apache.http.client;

 

/**
 * Implements SQL access for the SQL EMPLOYEE table
 *
 * @author Zowe Database API Generator
 * @since 1.0
 */
import java.io.*;
import java.net.*;

@Service("ADS Post EmployeeService")
@Slf4j
public class RunAdsPostService {
    
    public static void main(String args[]) {
        RunAdsPostService service = new RunAdsPostService();
        BigDecimal empid = new BigDecimal(1234);
        Employee e = service.new   Employee();
        try {
        	e.setEmpId(new BigDecimal(1234));
            e.setStreet(" 5 Affie Street");
            e.setCity("PampoenKloof");
            e.setState("ZA");
            e.setZipCode("12345");
            e = service.post("ddd", e.getEmpId(), e);
            print(e.getEmpFname() + " " + e.getEmpLname());

        } catch (Exception ee) {

            ee.printStackTrace();
        }
    }

    /**
     * SELECT exactly one row from the EMPLOYEE table
     * 
     * @param empId EMP_ID value
     * @return Employee object containing the contents of the data base record
     */
    public Employee post(String datasource, BigDecimal empId, Employee emp)
            throws   IOException {
        log.debug("EmployeeService.select({}, {})", datasource, empId);

        Employee employee = new Employee();
    
        Socket s = new Socket("192.168.24.227", 40117);
        DataInputStream din = new DataInputStream(s.getInputStream());
        DataOutputStream dout = new DataOutputStream(s.getOutputStream());
        BufferedReader br = new BufferedReader(new InputStreamReader(din));
       // doPost();
          // String data = "", str = "";
          log.debug("Dialog Premap - send:GET /emplj/update HTTP");
          // String req = "GET /demo/employee HTTP/1.1\r\nHost:www.example.com\r\n\r\n";
          String req = "GET /emplj/update HTTP/1.1\r\nHost:www.example.com\r\n\r\n";
          byte[] b = req.getBytes();
          char[] rb = new char[48176];
          dout.write(b, 0, b.length);
          dout.flush();
     //     dout.write(b, 0, b.length);
    //      dout.flush();
    log.debug("completed: send premap request ");
    log.debug("wait for response ");
  
    int i = -1;
    i = br.read(rb, 0, rb.length);
    log.debug("Received pm1 " + i + " bytes:" + makeString(rb, i));
    
    i = br.read(rb, 0, rb.length);
    log.debug("Received pm2 " + i + " bytes:" + makeString(rb, i));

          log.debug("dialog send Enter response  send:GET /emplj/update/enter?empid=" + empId.toString() + " HTTP");
          // req = "GET /demo/employee?empid=" + empId.toString() + " HTTP";
          req = "GET /emplj/update/enter?empid=" + empId.toString() + " HTTP";
          b = req.getBytes();
          dout.write(b, 0, b.length);
          dout.flush();
          i = br.read(rb, 0, rb.length);
          String rslt = makeString(rb, i);
          log.debug("Received1 should be 200ok: " + i + " bytes:" + rslt);
          i = br.read(rb, 0, rb.length);
          rslt = makeString(rb, i);
          log.debug("Received2 - should be resultset: " + i + " bytes:" + rslt);
       //   i = br.read(rb, 0, rb.length);
       //   rslt = makeString(rb, i);
      //    log.debug("received3 " + i + " bytes:" + makeString(rb, i));
          //rslt = rslt.substring(rslt.indexOf('{'));

          log.debug("dialog send POST request  send:POST /emplj/update/do?empid=" + empId.toString() + " HTTP");
        //   req = "POST /demo/employee?empid=" + empId.toString() + " HTTP";
       //   req = "POST /emplj/update/do?empid=" + empId.toString() + "&emp_street=Affie Straat&emp_city=BoggomsFontein HTTP";
          req = "POST /emplj/update/do?empid=" + empId.toString() + " HTTP";
          String parms = "empstreet=Affie Straat&empcity=BoggomsFontein";
       req += "\r\nContent-Length: "+parms.length()+"\r\n\r\n"+parms+".1.2.3.4 ";
       log.debug("request: "+req);
          b = req.getBytes();
          dout.write(b, 0, b.length);
          dout.flush();
          i = br.read(rb, 0, rb.length);
            rslt = makeString(rb, i);
          log.debug("PostReceived1 " + i + " bytes:" + rslt);
          i = br.read(rb, 0, rb.length);
          rslt = makeString(rb, i);
          log.debug("PostReceived2 " + i + " bytes:" + rslt);
        //  i = br.read(rb, 0, rb.length);
        //  rslt = makeString(rb, i);
        //  log.debug("received3 " + i + " bytes:" + makeString(rb, i));
     //     rslt = rslt.substring(rslt.indexOf('{'));
  
          log.debug("send after update Clear send:GET /demo/employee/clear HTTP");
          // req = "GET /demo/employee/clear HTTP";
          req = "GET /emplj/query/clear HTTP";
          b = req.getBytes();
          dout.write(b, 0, b.length);
          dout.flush();
          i = br.read(rb, 0, rb.length);
          log.debug("received4 " + i + " bytes:" + makeString(rb, i));
          dout.close();
        s.close();
        /*
         * employee
         * .setEmpId((BigDecimal)rs.getObject("EMP_ID"))
         * .setManagerId((BigDecimal)rs.getObject("MANAGER_ID"))
         * .setEmpFname((String)rs.getObject("EMP_FNAME"))
         * .setEmpLname((String)rs.getObject("EMP_LNAME"))
         * .setDeptId((BigDecimal)rs.getObject("DEPT_ID"))
         * .setStreet((String)rs.getObject("STREET"))
         * .setCity((String)rs.getObject("CITY"))
         * .setState((String)rs.getObject("STATE"))
         * .setZipCode((String)rs.getObject("ZIP_CODE"))
         * .setPhone((String)rs.getObject("PHONE"))
         * .setStatus((String)rs.getObject("STATUS"))
         * .setSsNumber((BigDecimal)rs.getObject("SS_NUMBER"))
         * .setStartDate((Date)rs.getObject("START_DATE"))
         * .setTerminationDate((Date)rs.getObject("TERMINATION_DATE"))
         * .setBirthDate((Date)rs.getObject("BIRTH_DATE"));
         * 
         */

        return employee;
    }
    public String doPost() throws UnsupportedEncodingException,IOException, ClientProtocolException,UnsupportedOperationException {
        CloseableHttpClient httpclient = HttpClients.createDefault();
        HttpPost httppost = new HttpPost("http://192.168.24.227:40117/emplj/update/do"  );
        InputStream instr=null ;
        // Request parameters and other properties.
        List<NameValuePair> params = new ArrayList<NameValuePair>(2);
        params.add(new BasicNameValuePair("empid", "1234"));
        params.add(new BasicNameValuePair("emp_street", "AffieStreet"));
        params.add(new BasicNameValuePair("emp_city", "boegomfontein"));
        httppost.setEntity(new UrlEncodedFormEntity(params, "UTF-8"));
        
        //Execute and get the response.
        CloseableHttpResponse response = httpclient.execute(httppost);
        HttpEntity entity = response.getEntity();
        if (entity != null) {
            instr =  entity.getContent();
            try (InputStream instream = entity.getContent()) {
                instr = instream;
            }
        }
        if (instr!=null)
         return instr.toString();
        else
          return "";
    }
    public static String makeString(char[] a, int len) {
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < len; i++) {
            sb.append(a[i]);
        }
        return sb.toString();
    }
    public static void print(String str) {
        System.out.println(str);
    }

    /**
     * SELECT a result set from the EMPLOYEE table
     * 
     * @return Employee array containing the contents of the result set
     */
    /*
    public List<Employee> query(String datasource)
            throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
        log.debug("EmployeeService.query({})", datasource);

        List<Employee> array = new ArrayList<Employee>();
        try (Connection conn = dataSourceRouter.getConnection(datasource);
                PreparedStatement stmt = conn.prepareStatement(SQL_SELECT);) {
            try (ResultSet rs = stmt.executeQuery();) {
                while (rs.next()) {
                    Employee employee = new Employee();
                    employee
                            .setEmpId((BigDecimal) rs.getObject("EMP_ID"))
                            .setManagerId((BigDecimal) rs.getObject("MANAGER_ID"))
                            .setEmpFname((String) rs.getObject("EMP_FNAME"))
                            .setEmpLname((String) rs.getObject("EMP_LNAME"))
                            .setDeptId((BigDecimal) rs.getObject("DEPT_ID"))
                            .setStreet((String) rs.getObject("STREET"))
                            .setCity((String) rs.getObject("CITY"))
                            .setState((String) rs.getObject("STATE"))
                            .setZipCode((String) rs.getObject("ZIP_CODE"))
                            .setPhone((String) rs.getObject("PHONE"))
                            .setStatus((String) rs.getObject("STATUS"))
                            .setSsNumber((BigDecimal) rs.getObject("SS_NUMBER"))
                            .setStartDate((Date) rs.getObject("START_DATE"))
                            .setTerminationDate((Date) rs.getObject("TERMINATION_DATE"))
                            .setBirthDate((Date) rs.getObject("BIRTH_DATE"));
                    array.add(employee);
                }
            }
        }
        return array;
    }
*/
    public class Employee {
        private BigDecimal empId;
        private BigDecimal managerId;
        private String empFname;
        private String empLname;
        private BigDecimal deptId;
        private String street;
        private String city;
        private String state;
        private String zipCode;
        private String phone;
        private String status;
        private BigDecimal ssNumber;
        private Date startDate;
        private Date terminationDate;
        private Date birthDate;
        public BigDecimal getEmpId() {
            return empId;
        }
        public BigDecimal getManagerId() {
            return managerId;
        }
        public String getEmpFname() {
            return empFname;
        }
        public String getEmpLname() {
            return empLname;
        }
        public BigDecimal getDeptId() {
            return deptId;
        }
        public String getStreet() {
            return street;
        }
        public String getCity() {
            return city;
        }
        public String getState() {
            return state;
        }
        public String getZipCode() {
            return zipCode;
        }
        public String getPhone() {
            return phone;
        }
        public String getStatus() {
            return status;
        }
        public BigDecimal getSsNumber() {
            return ssNumber;
        }
        public Date getStartDate() {
            return startDate;
        }
        public Date getTerminationDate() {
            return terminationDate;
        }
        public Date getBirthDate() {
            return birthDate;
        }
        public void setEmpId(BigDecimal empId) {
            this.empId = empId;
        }
        public void setManagerId(BigDecimal managerId) {
            this.managerId = managerId;
        }
        public void setEmpFname(String empFname) {
            this.empFname = empFname;
        }
        public void setEmpLname(String empLname) {
            this.empLname = empLname;
        }
        public void setDeptId(BigDecimal deptId) {
            this.deptId = deptId;
        }
        public void setStreet(String street) {
            this.street = street;
        }
        public void setCity(String city) {
            this.city = city;
        }
        public void setState(String state) {
            this.state = state;
        }
        public void setZipCode(String zipCode) {
            this.zipCode = zipCode;
        }
        public void setPhone(String phone) {
            this.phone = phone;
        }
        public void setStatus(String status) {
            this.status = status;
        }
        public void setSsNumber(BigDecimal ssNumber) {
            this.ssNumber = ssNumber;
        }
        public void setStartDate(Date startDate) {
            this.startDate = startDate;
        }
        public void setTerminationDate(Date terminationDate) {
            this.terminationDate = terminationDate;
        }
        public void setBirthDate(Date birthDate) {
            this.birthDate = birthDate;
        }
    }
}
