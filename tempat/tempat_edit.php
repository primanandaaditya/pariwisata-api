<?php
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: GET, POST, PATCH, PUT, DELETE, OPTIONS');
    header('Access-Control-Allow-Headers: Origin, Content-Type, X-Auth-Token');

    require_once ('../koneksi.php');

    if (isset($_POST['nama']) ){

        $nama = $_POST['nama'];
        $alamat = $_POST['alamat'];
        $detail = $_POST['detail'];
        $id_kategori = $_POST['id_kategori'];
        $latitude = $_POST['latitude'];
        $longitude = $_POST['longitude'];
        $id = $_POST['id'];

        $sql = "CALL SP_TempatEdit(:palamat,:pdetail,:pid_kategori,:platitude,:plongitude,:pnama,:pid);";
        $stmt = $db->prepare($sql);
        $stmt->bindValue(':palamat',$alamat,PDO::PARAM_STR);
        $stmt->bindValue(':pdetail',$detail,PDO::PARAM_STR);
        $stmt->bindValue(':pid_kategori',$id_kategori,PDO::PARAM_STR);
        $stmt->bindValue(':platitude',$latitude,PDO::PARAM_STR);
        $stmt->bindValue(':plongitude',$longitude,PDO::PARAM_STR);
        $stmt->bindValue(':pnama',$nama,PDO::PARAM_STR);
        $stmt->bindValue(':pid',$id,PDO::PARAM_INT);
        $stmt->execute();

        $eror=false;
        $pesan='Data berhasil diedit';

    }else{
        $eror=true;
        $pesan='Parameter tidak mencukupi';
    }

    $arr=array("error"=>$eror,"pesan"=>$pesan);
    echo json_encode($arr);

?>
