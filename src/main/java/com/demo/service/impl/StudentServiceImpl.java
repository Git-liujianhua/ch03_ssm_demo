package com.demo.service.impl;

import com.demo.dao.StudentDao;
import com.demo.entity.Student;
import com.demo.service.StudentService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class StudentServiceImpl implements StudentService {

    @Resource
    private StudentDao studentDao;

    @Override
    public int addStudent(Student student) {
        int nums = studentDao.insertStudent(student);
        return nums;
    }

    @Override
    public int alterStudent(Student student) {
        int nums = studentDao.updateStudent(student);
        return nums;
    }

    @Override
    public int removeStudentById(Integer id) {
        int nums = studentDao.deleteStudentById(id);
        return nums;
    }

    @Override
    public int removeStudent(List<Integer> ids) {
        int nums = studentDao.deleteStudent(ids);
        return nums;
    }

    @Override
    public Student queryStudentById(Integer id) {
        Student student = studentDao.selectStudentById(id);
        return student;
    }

    @Override
    public List<Student> queryStudent() {
        List<Student> students = studentDao.selectFullStudent();
        return students;
    }
}
