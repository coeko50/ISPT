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

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
 

 

/**
 * Implements SQL access for the SQL EMPLOYEE table
 *
 * @author Zowe Database API Generator
 * @since 1.0
 */
import java.io.*;
import java.net.*;

@Service("ADS EmployeeService")
@Slf4j
public class RunAdsService {
    Employee emp;
    public static void main(String args[]) {
        RunAdsService service = new RunAdsService();
        BigDecimal empid = new BigDecimal(31);
     //   service.emp = new Employee();
        try {
            service.emp = service.get("ddd", empid);
            print(service.emp.getEmpFname() + " " + service.emp.getEmpLname());

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
    public Employee get(String datasource, BigDecimal empId)
            throws   IOException {
        log.debug("EmployeeService.select({}, {})", datasource, empId);

        Employee employee = new Employee();
    
        Socket s = new Socket("192.168.24.227", 40117);
        DataInputStream din = new DataInputStream(s.getInputStream());
        DataOutputStream dout = new DataOutputStream(s.getOutputStream());
        BufferedReader br = new BufferedReader(new InputStreamReader(din));

        String data = "", str = "";
        print("Dialog Premap - send:GET /LRTESTD/premap HTTP");
        String req = "GET /LRTESTD/premap HTTP/1.1\r\nHost:www.example.com\r\n\r\n";
        byte[] b = req.getBytes();

        //dout.write(b, 0, b.length);
         dout.writeUTF(req);
        dout.flush();
        print("send done ");
        data = br.readLine();
//         data = din.readUTF();
        print("Received " + data);

        print("dialog send Enter response  send:GET /LRTESTD/enter?LR001W01_ERROR_CODE=1 HTTP");
        req = "GET /emplj/query/enter?empid=" + empId.toString() + " HTTP";
        b = req.getBytes();
       // dout.write(b, 0, b.length);
        dout.writeUTF(req);
        dout.flush();
      //  data = br.readLine();
        data = din.readUTF();
        print("Received " + data);
        print(data);
        print("send Clear send:GET /emplj/query/clear HTTP");
      //  dout.writeBytes("GET /emplj/query/clear HTTP");
      req="GET /emplj/query/clear HTTP";
        dout.writeUTF(req);
        dout.flush();
        data = din.readUTF();
        print("Received " + data);

        str = br.readLine();
        dout.writeUTF(str);
        dout.flush();
        str = din.readUTF();
        System.out.println("Server says: " + str);

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
    private class Employee {
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
