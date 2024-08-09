<?php
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: GET, POST, PATCH, PUT, DELETE, OPTIONS');
    header('Access-Control-Allow-Headers: Origin, Content-Type, X-Auth-Token');

    require_once ('../koneksi.php');

    $sql = "CALL SP_UserExceptAdmin";
    $stmt = $db->prepare($sql);
    $param = array();

    $stmt->execute($param);

    $hasil = array();
    while ( $tempat = $stmt->fetch(PDO::FETCH_ASSOC)){
        $hasil[] = $tempat;
    }

    $pesan = $hasil;
    $eror = false;

    $arr=array("error"=>$eror,"pesan"=>$pesan);
    echo json_encode($arr);
?>
