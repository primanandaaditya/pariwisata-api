<?php
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: GET, POST, PATCH, PUT, DELETE, OPTIONS');
    header('Access-Control-Allow-Headers: Origin, Content-Type, X-Auth-Token');

    require_once ('../koneksi.php');

    if (isset($_POST['nama']) ){

        $nama = $_POST['nama'];

        $sql = "CALL SP_KategoriInsert(:pnama,@phasil);";
        $stmt = $db->prepare($sql);
        $stmt->bindValue(':pnama',$nama,PDO::PARAM_STR);
        $stmt->execute();

        $sql = "SELECT @phasil;";
        $stmt = $db->prepare($sql);
        $stmt->execute();
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        $eror=false;
        $pesan=$user['@phasil'];

    }else{
        $eror=true;
        $pesan='Parameter tidak mencukupi';
    }

    $arr=array("error"=>$eror,"pesan"=>$pesan);
    echo json_encode($arr);

?>
