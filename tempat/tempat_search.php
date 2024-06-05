<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PATCH, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Origin, Content-Type, X-Auth-Token');

require_once ('../koneksi.php');

if (isset($_POST['key']) ){

    $key = $_POST['key'];

    $sql = "CALL SP_TempatSearch(:pkey);";
    $stmt = $db->prepare($sql);
    $param = array(
        ":pkey" => $key
    );
    $stmt->execute($param);

    $hasil = array();
    while ( $tempat = $stmt->fetch(PDO::FETCH_ASSOC)){
        $hasil[] = $tempat;
    }

    $pesan = $hasil;
    $eror = false;

}else{
    $eror=true;
    $pesan='Parameter tidak mencukupi';
}

$arr=array("error"=>$eror,"pesan"=>$pesan);
echo json_encode($arr);

?>
