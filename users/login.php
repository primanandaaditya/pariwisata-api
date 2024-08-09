<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PATCH, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Origin, Content-Type, X-Auth-Token');

require_once ('../koneksi.php');

if (isset($_POST['nama']) ){

    $nama = $_POST['nama'];
    $password = $_POST['password'];

   

    $sql = "CALL SP_Login(:pnama,:ppassword);";
    $stmt = $db->prepare($sql);
    $param = array(
        ":pnama" => $nama,
        ":ppassword" => md5($password)
    );
    $stmt->execute($param);

   
   
    $user = $stmt->fetch(PDO::FETCH_ASSOC);
        
    $eror = false;
    $pesan = $user;

}else{
    $eror=true;
    $pesan='Parameter tidak mencukupi';
}

$arr=array("error"=>$eror,"pesan"=>$pesan);
echo json_encode($arr);

?>
