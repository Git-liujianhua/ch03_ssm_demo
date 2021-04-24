package com.demo.dao;

import com.demo.entity.Student;

import java.util.List;

public interface StudentDao {

    int insertStudent(Student student);

    int updateStudent(Student student);

    int deleteStudentById(Integer id);

    int deleteStudent(List<Integer> ids);

    Student selectStudentById(Integer id);

    List<Student> selectFullStudent();
}
