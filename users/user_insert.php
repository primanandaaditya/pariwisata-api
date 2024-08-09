<?php
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: GET, POST, PATCH, PUT, DELETE, OPTIONS');
    header('Access-Control-Allow-Headers: Origin, Content-Type, X-Auth-Token');

    require_once ('../koneksi.php');

    if (isset($_POST['nama']) ){

        $nama = $_POST['nama'];
        $tipe = $_POST['tipe'];
        $role = $_POST['role'];
        $password=$_POST['password'];
        $alamat = $_POST['alamat'];
        $tempat = $_POST['tempat'];
        $tgllahir = $_POST['tgllahir'];
        $gender = $_POST['gender'];
        $id = $_POST['id'];

        
        $sql = "CALL SP_UserUpdate(:ptipe,:prole,:pnama,:ppassword,:palamat,:ptempat,:ptgllahir,:pgender,:pid);";
        $stmt = $db->prepare($sql);
        $stmt->bindValue(':ptipe',$tipe,PDO::PARAM_STR);
        $stmt->bindValue(':prole',$role,PDO::PARAM_STR);
        $stmt->bindValue(':pnama',$nama,PDO::PARAM_STR);
        $stmt->bindValue(':ppassword',$password,PDO::PARAM_STR);
        $stmt->bindValue(':palamat',$alamat,PDO::PARAM_STR);
        $stmt->bindValue(':ptempat',$tempat,PDO::PARAM_STR);
        $stmt->bindValue(':ptgllahir',$tgllahir,PDO::PARAM_STR);
        $stmt->bindValue(':pgender',$gender,PDO::PARAM_STR);
        $stmt->bindValue(':pid',$id,PDO::PARAM_STR);
        $stmt->execute();

        
        while ( $user = $stmt->fetch(PDO::FETCH_ASSOC)){
            $hasil = $user;
        }

        
    
        $arr=$hasil;
        echo json_encode($arr);

    }else{
        $eror=true;
        $pesan='Parameter tidak mencukupi';
        $arr=array("error"=>$eror,"pesan"=>$pesan);
        echo json_encode($arr);
    }

   

?>
