<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PATCH, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Origin, Content-Type, X-Auth-Token');

require_once ('../koneksi.php');

if (isset($_POST['id']) ){

    $id = $_POST['id'];

    $sql = "CALL SP_TempatDelete(:pid);";
    $stmt = $db->prepare($sql);
    $stmt->bindValue(':pid',$id,PDO::PARAM_STR);
    $stmt->execute();

    $eror=false;
    $pesan='Data berhasil dihapus';

}else{
    $eror=true;
    $pesan='Parameter tidak mencukupi';
}

$arr=array("error"=>$eror,"pesan"=>$pesan);
echo json_encode($arr);

?>
