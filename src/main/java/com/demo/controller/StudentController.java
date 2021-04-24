package com.demo.controller;

import com.demo.entity.Msg;
import com.demo.entity.Student;
import com.demo.service.StudentService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/student/")
public class StudentController {

    //创建Service对象
    @Resource
    private StudentService studentService;

    //查询分页数据
    @RequestMapping("queryStudent.do")
    @ResponseBody
    public Msg queryStudent(@RequestParam(value = "pn",defaultValue = "1")Integer pn){
        //调用Service的查询方法，蒋所有学生数据查询出来
        //使用分页，每页显示5行数据
        PageHelper.startPage(pn,5);
        List<Student> students = studentService.queryStudent();
        //将结果数据封装，页码显示5页
        PageInfo pageInfo = new PageInfo(students,5);
        return Msg.success().add("pageInfo",pageInfo);
    }

    //保存学生信息
    @RequestMapping(value = "saveStudent.do",method = RequestMethod.POST)
    @ResponseBody
    public Msg saveStudent(Student student){
        studentService.addStudent(student);
        return Msg.success();
    }

    //根据id查询学生信息
    // @RequestMapping(value = "getStudentById.do/{id}",method = RequestMethod.GET)
    @GetMapping("getStudentById.do/{id}")
    @ResponseBody
    public Msg getStudentById(@PathVariable("id") Integer id){
        Student student = studentService.queryStudentById(id);
        return Msg.success().add("student",student);
    }

    //修改学生信息
    @ResponseBody
    @RequestMapping(value = "updateStudent.do/{id}",method = RequestMethod.PUT)
    public Msg updateStudent(Student student){
        int nums = studentService.alterStudent(student);
        return Msg.success();
    }

    //单个和批量删除学生
    @RequestMapping(value = "deleteStudent.do/{ids}",method = RequestMethod.DELETE)
    @ResponseBody
    public Msg deleteStudent(@PathVariable("ids") String ids){
        //有”-“为批量删除，没有的事单个删除
        if (ids.contains("-")){
            //批量
            List<Integer> del_ids = new ArrayList<>();
            String[] str_ids = ids.split("-");
            for (String str :str_ids){
                del_ids.add(Integer.parseInt(str));
            }
            studentService.removeStudent(del_ids);
        }else {
            //单个
            int nums = studentService.removeStudentById(Integer.parseInt(ids));
        }

        return Msg.success();
    }





}
