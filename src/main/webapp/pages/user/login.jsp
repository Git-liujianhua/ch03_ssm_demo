<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <%@ include file="/pages/common/head.jsp"%>
    <script type="text/javascript">
        //页面加载完成之后
        $(function() {
            //给登录绑定单击事件
            $("#sub_btn").click(function () {
                // 验证用户名：必须由字母，数字以及下划线组成，并且长度为5到12位
                //1、获取用户名输入框里的内容
                var usernameText = $("#username").val();
                //2、创建正则表达式的对象
                var usernamePatt = /^\w{5,12}$/;
                //3、使用test方法验证
                if (!usernamePatt.test(usernameText)) {
                    //4、提示用户结果
                    $("span.errorMsg").text("用户名不合法");
                    return false;
                }

                // 验证密码：必须由字母，数字以及下划线组成，并且长度为5到12位
                //1、获取密码输入框中的内容
                var passwordText = $("#password").val();
                //2、创建正则表达式的对象
                var passwordPatt = /^\w{1,12}$/;
                //3、使用test方法验证
                if (!passwordPatt.test(passwordText)) {
                    //4、提示用户结果
                    $("span.errorMsg").text("密码不合法");
                    return false;
                }
            });
        });
    </script>
</head>
<body>
<div align="center">
    <div class="row">
        <div class="col-md-12">
            <h3>${tips}</h3>
            <span class="errorMsg"></span>
        </div>
    </div>
    <form action="user/loginUser.do" method="post">
        <table>
            <div class="form-group col-md-6">
                <tr>
                    <td><label>用户名：</label></td>
                    <td><input type="text" class="form-control" name="username" id="username"></td>
                </tr>
            </div>
            <div class="form-group col-md-6">
                <tr>
                    <td><label>密码：</label></td>
                    <td><input type="password" class="form-control" name="password" id="password"></td>
                </tr>
            </div>
            <div class="form-group col-md-6">
                <tr>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td><input type="submit" class="btn btn-primary" value="登录" id="sub_btn"/></td>
                </tr>
            </div>
        </table>
    </form>
</div>
</body>
</html>
