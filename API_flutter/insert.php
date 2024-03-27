<?php 
    mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
    include 'conn.php';

    $name = $_POST['name'];
    $item = $_POST['item'];
    $photo = $_FILES;

    $imagePath = "img/".$name."_".$item.".jpg";
    $imgformattedname = $name."_".$item.".jpg";

    move_uploaded_file($_FILES['image']['tmp_name'],$imagePath);

    $sql = "INSERT INTO tb_users VALUES('', '$name', '$item', '$imgformattedname')";
    
    mysqli_query($db, $sql);
?>

