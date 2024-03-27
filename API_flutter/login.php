<?php 
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
    include 'conn.php'; //database host

    $return["error"] = false;
    $return["message"] = "";
    $return["success"] = false;

  if(isset($_POST["username"]) && isset($_POST["password"])){ 
       //checking if there is POST data

       $username = $_POST["username"];
       $password = $_POST["password"];

       $username = mysqli_real_escape_string($db, $username);
       //escape inverted comma query conflict from string

       
       $sql = "SELECT * FROM tb_accounts WHERE username = '$username'";
       
       //building SQL query 
       $res = mysqli_query($db, $sql);

       $numrows = mysqli_num_rows($res);

       //check if there is any row
       if($numrows > 0){
           //if there is any data with that name
           $obj = mysqli_fetch_object($res);
           //get row as object
           if($password == $obj->password){
               $return["success"] = true;
           }else{
               $return["error"] = true;
               $return["message"] = "Your Password is Incorrect.";
           }
       }else{
           $return["error"] = true;
           $return["message"] = 'No username found.';
       }
  }else{
      $return["error"] = true;
      $return["message"] = 'Send all parameters.';
  }

  mysqli_close($db);

  header('Content-Type: application/json');
  // tell browser that its a json data

  echo json_encode($return);
?>