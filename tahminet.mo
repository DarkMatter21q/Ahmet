import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Random "mo:base/Random";
import Result "mo:base/Result";
import Float "mo:base/Float";

actor Tahminet {
  type OyunDurumu = {
    hedefSayi: Nat;
    kalanHak: Nat;
    tamamlandi: Bool;
  };

  stable var aktifOyun : ?OyunDurumu = null;
  stable var toplamOyunSayisi : Nat = 0;
  stable var kazanilanOyunSayisi : Nat = 0;

  public func oyunuBaslat() : async Result.Result<Text, Text> {
    if (aktifOyun != null) {
      return #err("Zaten devam eden bir oyun var!");
    };

    // Güvenli rastgele sayı üretme
    let seed = await Random.blob();
    let random = Random.Finite(seed);
    let hedefSayi = random.range(7); // 0-127 arası sayı üret
    switch (hedefSayi) {
      case (null) { 
        return #err("Sayı üretilemedi");
      };
      case (?sayi) {
        let yeniOyun : OyunDurumu = {
          hedefSayi = sayi;
          kalanHak = 7;
          tamamlandi = false;
        };
        
        aktifOyun := ?yeniOyun;
        toplamOyunSayisi += 1;
        
        return #ok("Oyun başladı! 0-127 arasında bir sayı tahmin edin.");
      };
    }
  };

  public func tahminEt(tahmin : Nat) : async Result.Result<Text, Text> {
    switch (aktifOyun) {
      case (null) { 
        return #err("Önce oyunu başlatın!"); 
      };
      case (?oyun) {
        if (oyun.tamamlandi) {
          return #err("Oyun zaten tamamlandı. Yeni bir oyun başlatın.");
        };

        if (oyun.kalanHak == 0) {
          aktifOyun := null;
          return #err("Hakkınız bitti! Doğru sayı: " # Nat.toText(oyun.hedefSayi));
        };

        let yeniOyun = if (tahmin == oyun.hedefSayi) {
          kazanilanOyunSayisi += 1;
          {
            hedefSayi = oyun.hedefSayi;
            kalanHak = oyun.kalanHak;
            tamamlandi = true;
          }
        } else {
          {
            hedefSayi = oyun.hedefSayi;
            kalanHak = 
              if (oyun.kalanHak > 0) { oyun.kalanHak - 1 }
              else { 0 }; 
            tamamlandi = false;
          }
        };

        aktifOyun := ?yeniOyun;

        if (yeniOyun.tamamlandi) {
          return #ok("Tebrikler! Doğru sayıyı buldunuz!");
        } else {
          // Mesafe hesaplama
          let fark = 
            if (tahmin < oyun.hedefSayi) { oyun.hedefSayi - tahmin }
            else { tahmin - oyun.hedefSayi };

          // Sıcaklık durumu
          let sicaklikDurumu = 
            if (fark <= 2) { "Kaynıyor!" } 
            else if (fark <= 5) { "Çok sıcak!" } 
            else if (fark <= 15) { "Sıcak." } 
            else if (fark <= 30) { "Soğuk." } 
            else if (fark <= 50) { "Çok Soğuk." } 
            else { "Dondun!" };

          if (tahmin < oyun.hedefSayi) {
            return #ok(" => " # sicaklikDurumu # " Kalan hak: " # Nat.toText(yeniOyun.kalanHak));
          } else {
            return #ok(" => " # sicaklikDurumu # " Kalan hak: " # Nat.toText(yeniOyun.kalanHak));
          }
        }
      }
    }
  };

  public query func oyunIstatistikleri() : async {
    toplamOyun: Nat;
    kazanilanOyun: Nat;
    kazanmaOrani: Float;
  } {
    {
      toplamOyun = toplamOyunSayisi;
      kazanilanOyun = kazanilanOyunSayisi;
      kazanmaOrani = 
        if (toplamOyunSayisi == 0) 0.0 
        else (Float.fromInt(kazanilanOyunSayisi) / Float.fromInt(toplamOyunSayisi)) * 100.0
    }
  };

  public func oyunuSifirla() : async Text {
    aktifOyun := null;
    return "Oyun sıfırlandı";
  };

  public query func kurallariGoster() : async Text {
    return
      "Oyunun Kuralları:\n" #
      "1. Oyun, 0 ile 127 arasında rastgele bir sayı üretir.\n" #
      "2. Oyuncunun doğru sayıyı bulmak için 7 hakkı vardır.\n" #
      "3. Tahmin yaptığınızda sıcak soğuk oyununda ki gibi bir ipucu alırsınız.\n" #
      "   - \"Kaynıyor!\": Doğru sayıya çok yakınsınız (fark ≤ 2).\n" #
      "   - \"Çok sıcak!\": Doğru sayıya yakınsınız (fark ≤ 5).\n" #
      "   - \"Sıcak.\": Orta mesafedesiniz (fark ≤ 15).\n" #
      "   - \"Soğuk.\": Sayıdan uzaksınız (fark ≤ 30).\n" #
      "   - \"Çok soğuk.\": Sayıdan çok uzaksınız (fark ≤ 50).\n" #
      "   - \"Dondun!\": Sayıya oldukça uzaksınız (fark > 50).\n" #
      "4. Doğru sayıyı tahmin ettiğinizde oyun tamamlanır.\n" #
      "5. Tahmin hakkınız bittiğinde oyun sona erer ve doğru sayı açıklanır.\n" #
      "6. Yeni bir oyun başlatmak için \"oyunu sıfırla\" komutunu kullanın.\n";
  };
}
