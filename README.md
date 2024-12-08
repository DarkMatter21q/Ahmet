# Ahmet

Sayılar ile tahmin et oyunu (sıcak soğuk)
Bu kod Motoko dilinde yazılmış olup bir tahmin oyununu simüle eder. Oyuncular, 0 ile 127 arasında rastgele üretilen bir sayıyı tahmin etmeye çalışır. Oyuncuların 7 tahmin hakkı vardır ve her tahminde sıcak-soğuk ipuçları verilir. Programın ana özellikleri ve işlevleri şunlardır:

*OyunDurumu: Oyun durumunu tanımlar; hedef sayıyı, kalan tahmin hakkını ve oyunun tamamlanıp tamamlanmadığını belirtir.
*aktifOyun: Durum göstericisi olarak, o anda aktif olan oyun durumunu tutar.
*toplamOyunSayisi: Oynanan oyun sayısını izler.
*kazanilanOyunSayisi: Kazanılan oyun sayısını izler.

Fonksiyonlar:
1) oyunuBaslat(): Oyunu başlatır ve bir hedef sayı üretir. Eğer oyun zaten devam ediyorsa bir hata döner.
2) tahminEt(tahmin: Nat): Oyuncunun tahminini alır, kalan hakları kontrol eder ve tahminin doğru olup olmadığını belirterek ipuçları sağlar.
3) oyunIstatistikleri(): Oynanan oyunların toplam sayısını, kazanılan oyun sayısını ve kazanma oranını döner.
4) oyunuSifirla(): Oyun durumu sıfırlar ve yeni bir oyun başlatır.
5) kurallariGoster(): Oyunun kurallarını açıklar.

İpuçları:
Tahminin doğruluğuna göre "Kaynıyor!", "Çok sıcak!", "Sıcak.", "Soğuk.", "Çok soğuk." ve "Dondun!" gibi durumlar döner.
Bu program, kullanıcıların doğru sayıyı bulmak için tahmin yapmalarını sağlar ve her tahminde doğru sayıdan ne kadar uzak olduklarını gösterir.

Sonuç:
Bu oyun kullanıcılarına analitik düşünme becerilerini geliştirme ve doğrusal tahmin yeteneklerini test etme fırsatı sunarak eğlenceli ve öğretici bir deneyim sağlar.
