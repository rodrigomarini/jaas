<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCtype html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Login page</title>
  </head>
  <body>
    <form method="POST" action="j_security_check">
      <label for="j_username">e-mail:</label>
      <input type="text" name="j_username" />
      <label for="j_password">password:</label>
      <input type="password" name="j_password" />
      <input type="submit" value="Login" />
    </form>
  </body>
</html>