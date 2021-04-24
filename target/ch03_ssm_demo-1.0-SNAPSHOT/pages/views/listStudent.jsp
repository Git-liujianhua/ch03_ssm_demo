<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
    <title>Title</title>
    <%@ include file="/pages/common/head.jsp"%>
    <script type="text/javascript">

        var totalRecord,currentPage;
        // 页面加载完成后直接发送一个ajax请求，得到分页数据
        $(function (){

            // 调用ajax
            to_page(1)
            //调用新增模态框
            $("#stu_add_modal_btn").click(function (){
                $("#studentAddModal").modal({
                    backdrop:"static"
                });
            });
            //调用修改模态框
            $(document).on("click",".edit_btn",function (){
                getStudent($(this).attr("edit_id"))
                $("#stu_update_btn").attr("edit_id",$(this).attr("edit_id"))
                $("#studentUpdateModal").modal({
                    backdrop:"static"
                });
            })
            //保存
            $("#stu_add_btn").click(function (){
                // 验证邮箱：xxxx@xxx.com
                //1、获取邮箱文本框中的内容
                var emailText = $("#stuEmail_add_input").val();
                //2、创建正则表达式的对象
                var emailPatt = /^[a-z\d]+(\.[a-z\d]+)*@([\da-z](-[\da-z])?)+(\.{1,2}[a-z]+)+$/;
                //3、使用test方法验证
                if (!emailPatt.test(emailText)){
                    //4、提示用户结果
                    alert("邮箱不合法")
                    return false;
                }
                $.ajax({
                    url:"student/saveStudent.do",
                    data:$("#studentAddModal form").serialize(),
                    type:"post",
                    success:function (result){
                        //关闭模态框
                        $("#studentAddModal").modal("hide");
                        //跳转最后添加数据的页面查看
                        to_page(totalRecord)
                    }
                })
            })
            // stu_update_btn修改保存
            $("#stu_update_btn").click(function (){
                // 验证邮箱：xxxx@xxx.com
                //1、获取邮箱文本框中的内容
                var emailText = $("#stuEmail_update_input").val();
                //2、创建正则表达式的对象
                var emailPatt = /^[a-z\d]+(\.[a-z\d]+)*@([\da-z](-[\da-z])?)+(\.{1,2}[a-z]+)+$/;
                //3、使用test方法验证
                if (!emailPatt.test(emailText)){
                    //4、提示用户结果
                    alert("邮箱不合法")
                    return false;
                }
                $.ajax({
                    url:"student/updateStudent.do/"+$(this).attr("edit_id"),
                    type:"put",
                    data:$("#studentUpdateModal form").serialize(),
                    success:function (result){
                        //关闭模态框
                        $("#studentUpdateModal").modal("hide");
                        //跳转最后添加数据的页面查看
                        to_page(currentPage)
                    }
                })
            })
            //删除
            $(document).on("click",".del_btn",function (){
                var stuName = $(this).parents("tr").find("td:eq(2)").text()
                if (confirm("确认删除学生【"+stuName+"】信息吗？")){
                    $.ajax({
                        url:"student/deleteStudent.do/"+$(this).attr("del_btn"),
                        type:"DELETE",
                        success:function (result){
                            alert("删除"+result.msg)
                            to_page(currentPage)
                        }
                    })
                }
            })
            //全选
            $("#checkbox_all").click(function (){
                $(".checkbox_item").prop("checked",$(this).prop("checked"))
            })
            $(document).on("click",".checkbox_item",function (){
                    var flag = $(".checkbox_item:checked").length == $(".checkbox_item").length
                    $("#checkbox_all").prop("checked",flag)
            })
            //stu_del_all_btn批量删除
            $("#stu_del_all_btn").click(function (){
                var stuNames = "";
                var del_idstr= "";
                $.each($(".checkbox_item:checked"),function (){
                    //员工字符串
                    stuNames += $(this).parents("tr").find("td:eq(2)").text()+","
                    //员工id字符串
                    del_idstr += $(this).parents("tr").find("td:eq(1)").text()+"-"
                })
                var subStuNames = stuNames.substring(0,stuNames.length-1)
                var subStuIds = del_idstr.substring(0,del_idstr.length-1)
                if (confirm("确认删除已选学生【"+subStuNames+"】信息吗？")){
                    $.ajax({
                        url:"student/deleteStudent.do/"+subStuIds,
                        type:"delete",
                        success:function (result){
                            alert(result.msg);
                            to_page(currentPage)
                        }
                    })
                }
            })
        })
        function getStudent(id){
            $.ajax({
                url:"student/getStudentById.do/"+id,
                type:"get",
                success:function (result){
                    // console.log(result)
                    var stu = result.extend.student;
                    $("#stuId_update_input").val(stu.id)
                    $("#stuName_update_input").val(stu.name)
                    $("#stuAge_update_input").val(stu.age)
                    $("#stuEmail_update_input").val(stu.email)
                }
            })
        }

        //发送ajax请求
        function to_page(pn){
            $.ajax({
                url:"student/queryStudent.do",
                data:"pn="+pn,
                type:"get",
                dataType:"json",
                success:function (result){
                    //调用解析数据的function
                    build_student(result);
                    //调用解析分页信息的function
                    build_pageInfo_info(result);
                    //调用解析分页条的function
                    build_pageInfo_nav(result);
                }
            })
        }
        //解析数据
        function build_student(result){
            //在发送请求之前先清空table数据
            $("#student_table tbody").empty();
            //获取分页数据
            var student = result.extend.pageInfo.list;
            //遍历
            $.each(student,function (n,i){
                var checkbox = $("<td></td>").append("<input type='checkbox' class='checkbox_item'>")
                var id = $("<td></td>").append(i.id);
                var name = $("<td></td>").append(i.name);
                var age = $("<td></td>").append(i.age);
                var email = $("<td></td>").append(i.email);
                var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn").append("编辑");
                editBtn.attr("edit_id",i.id)
                var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm del_btn").append("删除");
                delBtn.attr("del_btn",i.id)
                var td = $("<td></td>").append(editBtn).append("&nbsp;").append(delBtn);
                $("<tr></tr>").append(checkbox).append(id).append(name).append(age).append(email).append(td)
                    .appendTo("#student_table tbody")
            })
        }
        //解析分页信息
        function build_pageInfo_info(result){
            //在发送请求之前先清空分页数据
            $("#page_info").empty();
            //获取pageinfo中的分页信息
            var info = result.extend.pageInfo;
            totalRecord = info.total
            currentPage = info.pageNum
            $("#page_info").append("当前"+currentPage+"页，总共"+info.pages+"页，共"+totalRecord+"条记录")
        }

        //解析分页条
        function build_pageInfo_nav(result){
            //在发送请求之前先清空分页条
            $("#page_nav").empty();
            //加入nav标签
            var nav = $("<nav></nav>").attr("aria-label","Page navigation example")
            //加入ul标签
            var ul = $("<ul></ul>").addClass("pagination")
            //首页li
            var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").addClass("page-link"));
            //上一页li
            var prePageLi = $("<li></li>").append($("<a></a>")
                            .addClass("page-link").attr("aria-label","Previous")
                            .append($("<spen></spen>").attr("aria-hidden","true").append("&laquo;")));
            //如果上一页没有了传入class属性禁用按钮且警用点击事件，反之启用
            if (result.extend.pageInfo.hasPreviousPage == false){
                firstPageLi.addClass("page-item disabled")
                prePageLi.addClass("page-item disabled")
            }else {
                firstPageLi.addClass("page-item")
                prePageLi.addClass("page-item")
                //首页点击事件
                firstPageLi.click(function () {
                    to_page(1)
                })
                //下一页点击事件
                prePageLi.click(function () {
                    to_page(result.extend.pageInfo.pageNum - 1)
                })
            }
            //给ul中追加首页li和上一页li
            ul.append(firstPageLi).append(prePageLi)
            //遍历页码
            $.each(result.extend.pageInfo.navigatepageNums,function (n,i) {
                var numLi = $("<li></li>").append($("<a></a>").append(i).addClass("page-link"));
                //当前页高亮显示页码
                if (result.extend.pageInfo.pageNum == i){
                    numLi.addClass("page-item active")
                }else {
                    numLi.addClass("page-item")
                }
                //绑定点击事件
                numLi.click(function () {
                    to_page(i)
                })
                //ul中追加页码li
                ul.append(numLi)
            })
            //下一页
            var nextPageLi = $("<li></li>").append($("<a></a>")
                .addClass("page-link").attr("aria-label","Previous")
                .append($("<spen></spen>").attr("aria-hidden","true").append("&raquo;")));
            //最后一页
            var listPageLi = $("<li></li>").append($("<a></a>").append("尾页").addClass("page-link"));
            //如果下一页没有了传入class属性禁用按钮且警用点击事件，反之启用
            if (result.extend.pageInfo.hasNextPage == false){
                nextPageLi.addClass("page-item disabled")
                listPageLi.addClass("page-item disabled")
            }else {
                nextPageLi.addClass("page-item")
                listPageLi.addClass("page-item")
                nextPageLi.click(function () {
                    to_page(result.extend.pageInfo.pageNum + 1)
                })
                listPageLi.click(function () {
                    to_page(result.extend.pageInfo.pages)
                })
            }
            //ul中追加下一页和最后一页
            ul.append(nextPageLi).append(listPageLi)
            //nav中追加ul
            nav.append(ul)
            //将分页加入到div中
            nav.appendTo("#page_nav")
        }



    </script>
</head>
<body>
<!--新增学生-->
<div class="modal fade" id="studentAddModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addModalLabel">添加学生</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label">ID</label>
                        <div class="col-sm-10">
                            <input type="text" name="id" class="form-control" id="stuId_add_input" placeholder="id">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label">name</label>
                        <div class="col-sm-10">
                            <input type="text" name="name" class="form-control" id="stuName_add_input" placeholder="name">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label">age</label>
                        <div class="col-sm-10">
                            <input type="text" name="age" class="form-control" id="stuAge_add_input" placeholder="age">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label">email</label>
                        <div class="col-sm-10">
                            <input type="email" name="email" class="form-control" id="stuEmail_add_input" placeholder="email">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="stu_add_btn">Save changes</button>
            </div>
        </div>
    </div>
</div>

<!--修改学生-->
<div class="modal fade" id="studentUpdateModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="updateModalLabel">修改学生</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label">ID</label>
                        <div class="col-sm-10">
                            <input type="text" name="id" readonly class="form-control-plaintext" id="stuId_update_input" value="">
                            <%--<input type="text" name="id" class="form-control" id="stuId_update_input" placeholder="id">--%>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label">name</label>
                        <div class="col-sm-10">
                            <input type="text" name="name" class="form-control" id="stuName_update_input" placeholder="name">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label">age</label>
                        <div class="col-sm-10">
                            <input type="text" name="age" class="form-control" id="stuAge_update_input" placeholder="age">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-sm-2 col-form-label">email</label>
                        <div class="col-sm-10">
                            <input type="email" name="email" class="form-control" id="stuEmail_update_input" placeholder="email">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="stu_update_btn">Update changes</button>
            </div>
        </div>
    </div>
</div>
    <div class="container">
        <%--标题--%>
        <div class="row">
            <div class="col-md-12">
                <h3>${param.tips}</h3>
            </div>
        </div>
        <%--按钮--%>
        <div class="row">
            <div class="col-md-4 offset-md-8">
                <button class="btn btn-primary" id="stu_add_modal_btn">新增</button>
                <button class="btn btn-danger" id="stu_del_all_btn">删除</button>
            </div>
        </div>
        <%--表格数据--%>
        <div class="row">
            <div class="col-md-12">
                <table class="table table-hover" id="student_table">
                    <thead>
                        <tr>
                            <th>
                                <input type="checkbox" id="checkbox_all">
                            </th>
                            <th>#</th>
                            <th>name</th>
                            <th>email</th>
                            <th>age</th>
                            <th>operation</th>
                        </tr>
                    </thead>
                    <tbody>

                    </tbody>
                </table>
            </div>
        </div>
        <%--分页--%>
        <div class="row">
            <%--分页文字信息--%>
            <div class="col-md-6" id="page_info">

            </div>
            <%--分页条信息--%>
            <div class="col-md-6" id="page_nav">

            </div>
        </div>
    </div>
</body>
</html>
