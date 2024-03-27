<?php 
    mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
    include 'conn.php';

    $id = $_POST['id'];
    $photo = $_POST['photo'];

    $sql = "DELETE FROM tb_users WHERE id = $id";
    unlink("img/".$photo);

    mysqli_query($db, $sql);
?>