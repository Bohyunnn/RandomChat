package yapp.chattest.dao;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import yapp.chattest.model.Chat;

import javax.transaction.Transactional;
import java.util.List;

@Repository
@Transactional
public class ChatsDao {

    @Autowired
    private SessionFactory _sessionFactory;

    private Session getSession() {
        return _sessionFactory.getCurrentSession();
    }

    public void save(Chat chat) {
        getSession().save(chat);
    }

    public void delete(Chat chat) {
        getSession().delete(chat);
    }

    public List getAll() {
        return getSession().createQuery("from Chat").list();
    }
}
