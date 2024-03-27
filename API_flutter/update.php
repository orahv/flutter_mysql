<?php 
    mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
    include 'conn.php';

    $old_name = $_POST['old_name'];
    $old_item = $_POST['old_item'];
    $old_photo = $_POST['old_photo'];

    $id = $_POST['id'];
    $name = $_POST['name'];
    $item = $_POST['item'];
    $photo = $_POST['photo'];

    $imagePath = "img/".$name."_".$item.".jpg";
    $imgformattedname = $name."_".$item.".jpg";

    unlink("img/".$old_photo);
    move_uploaded_file($_FILES['image']['tmp_name'],$imagePath);

    $sql = "UPDATE tb_users SET name = '$name', item = '$item', photo = '$imgformattedname' WHERE id = $id";
    
    mysqli_query($db, $sql);
?>