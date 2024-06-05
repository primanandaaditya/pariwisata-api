<?php
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: GET, POST, PATCH, PUT, DELETE, OPTIONS');
    header('Access-Control-Allow-Headers: Origin, Content-Type, X-Auth-Token');

    require_once ('../koneksi.php');

    if (isset($_POST['nama']) ){

        //upload foto terlebih dulu
        //lakukan upload foto
        $path = '';
        if (isset($_FILES['foto'])){
            //letak folder dimana foto akan diupload
            $target_dir = "../foto/";
            $target_file = $target_dir . basename($_FILES["foto"]["name"]);
            $uploadOk = 1;
            $imageFileType = strtolower(pathinfo($target_file,PATHINFO_EXTENSION));

            // Check if image file is a actual image or fake image
            $check = getimagesize($_FILES["foto"]["tmp_name"]);
            if($check !== false) {
                $pesan = "Tipe file adalah - " . $check["mime"] . ". ";
                $eror = true;
            } else {
                $pesan = "Foto yang Anda masukkan bukan gambar.";
                $eror = true;
            }
            //cek apakah nama file duplikat
            if (file_exists($target_file)) {
                $pesan = "Maaf nama foto sudah ada.";
                $eror = true;
            }
            //periksa ukuran file
            if ($_FILES["foto"]["size"] > 500000) {
                $pesan = "Maaf, ukuran foto terlalu besar (lebih besar dari 500 MB).";
                $eror = true;
            }
            // Allow certain file formats
            if($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg"
                && $imageFileType != "gif" ) {
                $pesan = "Maaf, hanya file tipe JPG, JPEG, PNG & GIF yang diizinkan.";
                $eror = true;
            }
            if ($uploadOk == 0) {
                $pesan = "Maaf, foto tidak dapat diunggah.";
                $eror = true;
            } else {
                $temp = explode(".", $_FILES["foto"]["name"]);
                $newfilename = round(microtime(true)) . '.' . end($temp);
                $foto = $newfilename;
                //buat var baru untuk menentukan path
                //ini untuk menghapus gambar yang ke-upload kalau data duplikat
                //karena foto pasti diupload, sebelum cek duplikat nama produk
                $path = $target_dir . $newfilename;

                if (move_uploaded_file($_FILES["foto"]["tmp_name"], $target_dir . $newfilename)) {
                    $pesan = "Foto berhasil diunggah.";
                    $eror = false;
                } else {
                    $pesan = "Maaf, terjadi error.";
                    $eror = true;
                }
            }
        }

        $nama = $_POST['nama'];
        $alamat = $_POST['alamat'];
        $detail = $_POST['detail'];
        $id_kategori = $_POST['id_kategori'];
        $latitude = $_POST['latitude'];
        $longitude = $_POST['longitude'];

        $sql = "CALL SP_TempatInsert(:palamat,:pdetail,:pfoto,:pid_kategori,:platitude,:plongitude,:pnama,@phasil);";
        $stmt = $db->prepare($sql);
        $stmt->bindValue(':palamat',$alamat,PDO::PARAM_STR);
        $stmt->bindValue(':pdetail',$detail,PDO::PARAM_STR);
        $stmt->bindValue(':pfoto',$newfilename,PDO::PARAM_STR);
        $stmt->bindValue(':pid_kategori',$id_kategori,PDO::PARAM_STR);
        $stmt->bindValue(':platitude',$latitude,PDO::PARAM_STR);
        $stmt->bindValue(':plongitude',$longitude,PDO::PARAM_STR);
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
