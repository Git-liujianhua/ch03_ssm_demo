package com.demo.service;

import com.demo.entity.Student;

import java.util.List;

public interface StudentService {

    int addStudent(Student student);

    int alterStudent(Student student);

    int removeStudentById(Integer id);

    int removeStudent(List<Integer> ids);

    Student queryStudentById(Integer id);

    List<Student> queryStudent();

}
