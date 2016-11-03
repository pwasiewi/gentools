package pl.wit.sesja;

import javax.naming.InitialContext;
import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.cfg.Environment;

/**
 * Ta klasa inicjuje tylko jedną pojedynczą sesje poprzez  Hibernate SessionFactory. Można używać dowolnych klas z JTA or Thread transactionFactories.
 */
public class InitSessionFactory {

	private InitSessionFactory() {
	}

	/** Hibernate używa #resourceAsStream stylu do znajdowania konfiguracyjnego pliku, który powinien znajdować się gdzieś na ścieżce classpath
	 * Pzyk�ady:
	 * CONFIG_FILE_LOCATION = "/hibernate.conf.xml"
	 * CONFIG_FILE_LOCATION = "/com/bla/lol/hibertest.conf.xml"
	 */
	private static String CONFIG_FILE_LOCATION = "/hibernate.cfg.xml";

	/** pojedyncza konfiguracja hibernate */
	private static final Configuration cfg = new Configuration();

	/** pojedyncza sesja hibernate SessionFactory */
	private static org.hibernate.SessionFactory sessionFactory;

	public static SessionFactory getInstance() {
		if (sessionFactory == null)
			initSessionFactory();
		return sessionFactory;
	}

	public Session openSession() {
		return sessionFactory.getCurrentSession();
	}

	/**
	 * okre�lona w hibernate.cfg.xml
	 */
	public Session getCurrentSession() {
		return sessionFactory.getCurrentSession();
	}

	private static synchronized void initSessionFactory() {
		/* Jeszcze raz sprawdza sesj�
		 */
		Logger log = Logger.getLogger(InitSessionFactory.class);
		if (sessionFactory == null) {
			try {
				cfg.configure(CONFIG_FILE_LOCATION);
				String sessionFactoryJndiName = cfg
				.getProperty(Environment.SESSION_FACTORY_NAME);
				if (sessionFactoryJndiName != null) {
					cfg.buildSessionFactory();
					log.debug("get a jndi session factory");
					sessionFactory = (SessionFactory) (new InitialContext())
							.lookup(sessionFactoryJndiName);
				} else{
					log.debug("classic factory");
					sessionFactory = cfg.buildSessionFactory();
				}

			} catch (Exception e) {
				System.err
						.println("%%%% Error Creating HibernateSessionFactory %%%%");
				e.printStackTrace();
				throw new HibernateException(
						"Could not initialize the Hibernate configuration");
			}
		}
	}
	
	public static void close(){
		if (sessionFactory != null)
			sessionFactory.close();
		sessionFactory = null;
	
	}
}
