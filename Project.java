import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;
import java.sql.*;
import java.io.*;
/**
 * numarasi verilen bir calisanin isim ve maas bilgileri 
 */

public class Ornek2 {
	public static void main(String[] args) throws SQLException {
		String url = "jdbc:postgresql://localhost:5432/company_db";
		String user = "postgres";
		String pass = "1234";		
		Connection conn = DriverManager.getConnection(url,user,pass);
		
		String query = "SELECT fname, lname, salary FROM employee WHERE ssn = ?";
		
		PreparedStatement p = conn.prepareStatement(query);
        
        Scanner input = new Scanner(System.in); 
        System.out.print("Çalışanın SSN no'sunu giriniz: ");
        String ssn = input.nextLine(); 
        input.close();
       
        p.clearParameters();
        p.setString(1,ssn);
        
        ResultSet r = p.executeQuery();
        
        
        if (r.next ()) { 
            String fname = r.getString(1);
            String lname = r.getString(2);
            double salary = r.getDouble("salary"); 
            System.out.println(fname + " " + lname + " " + salary);
        }
        
        p.close();
        conn.close();
		
		
		
	}
	

}

/**
 * "DatabaseSystems" projesinde calisan kadin iscilerin ad, soyad ve maasları.
 */
public class Ornek_2 {
    public static void main (String args []) throws SQLException, IOException {
        String user, pass;
        user = "postgres";
        pass = "1234";
        Connection conn =
	DriverManager.getConnection("jdbc:postgresql://localhost:5432/company_db", user,pass);
        
        String query = "SELECT fname, lname, salary FROM employee e, works_on w, project p" 
                     + " WHERE w.essn=e.ssn AND w.pno=p.pnumber AND e.sex='F' AND"
                     + " pname='DatabaseSystems'";

        Statement s = conn.createStatement();
        ResultSet r = s.executeQuery(query);
        
        while (r.next()) {
            String fname = r.getString(1);
            String lname = r.getString(2);
            double salary = r.getDouble(3);
            System.out.println(fname + " " + lname + " " + salary);
        }
        s.close();
        conn.close();
        
    }        
}


/**
 * "Chicago" da bulunan departman(lar)da calisan iscilerin isim ve maas bilgileri.
 */
public class Soru_2 {
    public static void main (String args []) throws SQLException, IOException {
        String user, pass;
        user = "postgres";
        pass = "1234";
        Connection conn =
	DriverManager.getConnection("jdbc:postgresql://localhost:5432/company_db", user,pass);
                
        String query = "SELECT fname, lname, salary FROM employee e," +
                       " dept_locations dl WHERE e.dno = dl.dnumber AND dlocation = 'Chicago'";

        Statement s = conn.createStatement();
        ResultSet r = s.executeQuery(query);
        
        while (r.next()) {
            String fname = r.getString(1);
            String lname = r.getString(2);
            double salary = r.getDouble(3);
            System.out.println(fname + " " + lname + " " + salary);
        }
        
        s.close();
        conn.close();
    }          
}

/**
 *  Her bir departmandaki calisanlarin sayisi ve departman ismine gore alfabetik olarak listelenmesi.
 */
public class Soru_3 {
    public static void main (String args []) throws SQLException, IOException {
        String user, pass;
        user = "postgres";
        pass = "1234";
        Connection conn =
	DriverManager.getConnection("jdbc:postgresql://localhost:5432/company_db", user,pass);
        
        String query = "SELECT dname, COUNT(*) FROM department d, employee e" +
                       " WHERE d.dnumber = e.dno GROUP BY dname ORDER BY dname";

        Statement s = conn.createStatement();
        ResultSet r = s.executeQuery(query);
        
        while (r.next()) {
            String dname = r.getString(1);
            int count = r.getInt(2);
            System.out.println(dname + " " + count);
        }
        
        s.close();
        conn.close();
    }               
}

/**
 * "ProductX" projesinde kac kisinin calistigi ve bu calisanlarin ortalama maasi.
 */
public class Soru_4 {

    public static void main (String args []) throws SQLException, IOException {
        String user, pass;
        user = "postgres";
        pass = "1234";
        Connection conn =
	DriverManager.getConnection("jdbc:postgresql://localhost:5432/company_db", user,pass);
        
               
        String query =  "SELECT COUNT(*), AVG(salary) FROM employee e, project p, works_on w" +
                        " WHERE e.ssn = w.essn AND p.pnumber = w.pno AND pname = 'ProductX'";

        Statement s = conn.createStatement();
        ResultSet r = s.executeQuery(query);
        
        while (r.next()) {
            int count = r.getInt(1);
            double ort_maas = r.getDouble(2);
            System.out.println(count + " " + ort_maas);
        }
        
        s.close();
        conn.close();
    }               
}

public class Ornek1 {
	
	public static void main(String[] args) throws SQLException {
		String url = "jdbc:postgresql://localhost:5432/company_db";
		String user = "postgres";
		String pass = "1234";		
		Connection conn = DriverManager.getConnection(url,user,pass);
		
		Statement s = conn.createStatement();
		
		String query = "INSERT INTO employee(fname,lname,ssn) VALUES('Elcin','Guveyi','121212121')";
		String query2 = "DELETE FROM employee where ssn='121212121'";
		
		s.executeUpdate(query2);
		
		s.close();
		conn.close();
				
	}

}

// 5 numaralı departmanda çalışanların ad-soyad-maas bilgileri.
public class Ornek {

	public static void main(String[] args) throws SQLException {
		String url = "jdbc:postgresql://localhost:5432/company_db";
		String user = "postgres";
		String pass = "1234";		
		Connection conn = DriverManager.getConnection(url,user,pass);
		
		String query = "SELECT fname,lname,salary FROM employee where dno=5";
		
		Statement s = conn.createStatement();
		ResultSet r = s.executeQuery(query);
		
		while(r.next()){
			String ad = r.getString(1);
			String soyad = r.getString(2);
			int maas = r.getInt("salary");  
			
			System.out.println(ad + " " + soyad +" " +maas);
					
		}
		
		ResultSetMetaData rsmd = r.getMetaData(); 
		System.out.println(rsmd.getColumnCount());
		System.out.println(rsmd.getColumnTypeName(2));
		
		
		
		s.close();
		conn.close();
				
	}
	
}
