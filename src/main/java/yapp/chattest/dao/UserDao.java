package yapp.chattest.dao;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import yapp.chattest.model.User;

import javax.transaction.Transactional;

import java.util.List;

@Repository
@Transactional
public class UserDao {

    @Autowired
    private SessionFactory _sessionFactory;

    private Session getSession() {
        return _sessionFactory.getCurrentSession();
    }

    public void save(User user) {
        getSession().save(user);
    }

    public void delete(User user) {
        getSession().delete(user);
    }

    public List getAll() {
        return getSession().createQuery("from User").list();
    }

    public User getByName(String name) {
        return (User) getSession().createQuery(
                "from User where name = :name")
                .setParameter("name", name) //매개변수 값 지정
                .uniqueResult(); 			//단일 값으로 얻어옴.
    }

    public User getById(Long id) {
        return (User) getSession().load(User.class, id);
    }

    public void update(User user) {
        getSession().update(user);
    }
}
