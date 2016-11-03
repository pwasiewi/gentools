package pl.wit.przyklad;

import java.util.Iterator;
import java.util.List;
import java.io.*;
import java.security.*;
import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.Calendar;
import java.util.GregorianCalendar;
import org.hibernate.*;
import org.hibernate.cfg.*;
import org.hibernate.criterion.*;


import pl.wit.sesja.InitSessionFactory;
 
public class Testowa {

	private static Logger log =Logger.getLogger(Testowa.class);
	
	public static void main(String[] args) {
		System.out.println (md5 ("Hello, world!"));
		
		Kategorie k1=new Kategorie();
		k1.setNazwa_kategorii("High");
		k1.setUpust(0.42);
		createObject(k1);
		
		Kategorie k2=new Kategorie();
		k2.setNazwa_kategorii("Low");
		k2.setUpust(0.15);
		createObject(k2);
		
		Rodzaje r1=new Rodzaje();
		r1.setNazwa_rodzaju("Indywidualny");
		r1.setZnizka(0.42);
		createObject(r1);
		
		Rodzaje r2=new Rodzaje();
		r2.setNazwa_rodzaju("Korporacyjny");
		r2.setZnizka(0.15);
		createObject(r2);
		
		
		Klient pierwszyKlient = new Klient();
		pierwszyKlient.setNazwisko("Pankracy");
		pierwszyKlient.setImie("Piotr");
		pierwszyKlient.setRodzaj(r1);
		pierwszyKlient.setLogin("pankracy");
		pierwszyKlient.setPasswd(md5("sdawkowo"));
		createObject(pierwszyKlient);
		
		Klient drugiKlient = new Klient();
		drugiKlient.setNazwisko("Dacki");
		drugiKlient.setImie("Rafa³");
		drugiKlient.setRodzaj(r2);
		drugiKlient.setLogin("dacki");
		drugiKlient.setPasswd(md5("wazne"));
		createObject(drugiKlient);
		
		//log.debug(pierwszyKlient);
		//log.debug(drugiKlient);
		listObjects("select h from Klient as h");
		// mo¿na usuwaæ po kluczu g³ównym
	    deleteObject(pierwszyKlient);
	    listObjects("select h from Klient as h");
	
        //Klucz g³ówny z³o¿ony
        Klient_katKey kk = new Klient_katKey();
        kk.setId_klienta(drugiKlient);
        kk.setKategoria(k1);

        Klient_kat kkt = new Klient_kat();
        kkt.setId(kk);
        kkt.setData_rozp(new GregorianCalendar(2008, 0, 1));
        kkt.setUwagi("Wszystko w porz±dku!");
        createObject(kkt);
        
        listObjects("select kk from Klient_kat as kk");
        //Query q = s.createQuery("from Person where birthDate > :date");
        //q.setCalendar("date", new GregorianCalendar(1970, 0, 1));

        listKlientwithCriteria();
        listKlient_katwithCriteria();		
	}

public static String hex(byte[] array) {
	StringBuffer sb = new StringBuffer();
     	for (int i = 0; i < array.length; ++i) {
         	sb.append(Integer.toHexString((array[i] & 0xFF) | 0x100).toUpperCase().substring(1,3));
        }
     	return sb.toString();
}

public static String md5 (String message) { 
       	try { 
            	MessageDigest md = MessageDigest.getInstance("MD5"); 
            	return hex (md.digest(message.getBytes("UTF8"))); 
        } catch (NoSuchAlgorithmException e) { 
        } catch (UnsupportedEncodingException e) { 
        }
       	return null;
}

private static void listKlient_katwithCriteria() {
	Transaction tx = null;
	Session session = InitSessionFactory.getInstance().getCurrentSession();
	try {
		tx = session.beginTransaction();
		Criteria q = session.createCriteria(Klient_kat.class);
		q.add(Restrictions.isNotNull("data_rozp"));
        q.addOrder(Order.asc("data_rozp"));

        for (Klient_kat p : (List<Klient_kat>) q.list()) {
        	log.debug(p);
            System.out.println(p);
        }
		tx.commit();
	} catch (HibernateException e) {
		e.printStackTrace();
		if (tx != null && tx.isActive())
			tx.rollback();

	}
}


private static void listKlientwithCriteria() {
	Transaction tx = null;
	Session session = InitSessionFactory.getInstance().getCurrentSession();
	try {
		tx = session.beginTransaction();
		Criteria q = session.createCriteria(Klient.class);
        q.add(Restrictions.like("nazwisko", "Da%"));
        q.addOrder(Order.asc("nazwisko"));

        for (Klient p : (List<Klient>) q.list()) {
        	log.debug(p);
            //System.out.println("Imiê: " + p.getImiê());
        }
		tx.commit();
	} catch (HibernateException e) {
		e.printStackTrace();
		if (tx != null && tx.isActive())
			tx.rollback();

	}
}

private static void listObjects(String query) {
	Transaction tx = null;
	Session session = InitSessionFactory.getInstance().getCurrentSession();
	try {
		tx = session.beginTransaction();
		List objects = session.createQuery(query).list();
		for (Iterator iter = objects.iterator(); iter.hasNext();) {
			Serializable element = (Serializable) iter.next();
            System.out.println(element);
			//log.debug(element);
		}
		tx.commit();
	} catch (HibernateException e) {
		e.printStackTrace();
		if (tx != null && tx.isActive())
			tx.rollback();

	}
}

private static void deleteObject(Serializable so) {
		Transaction tx = null;
		Session session = InitSessionFactory.getInstance().getCurrentSession();
		try {
			tx = session.beginTransaction();
			session.delete(so);
			tx.commit();
		} catch (HibernateException e) {
			e.printStackTrace();
			if (tx != null && tx.isActive())
				tx.rollback();
		}
	}

private static void createObject(Serializable so) {
	Transaction tx = null;
	Session session = InitSessionFactory.getInstance().getCurrentSession();
	try {
		tx = session.beginTransaction();
		session.save(so);
		tx.commit();
	} catch (HibernateException e) {
		e.printStackTrace();
		if (tx != null && tx.isActive())
			tx.rollback();
	}
}

}
