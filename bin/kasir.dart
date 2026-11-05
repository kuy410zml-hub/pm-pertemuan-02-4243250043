import 'dart:io';

void main() {
  const String namaToko = 'KASIR TOKO OLEH-OLEH MEDAN';
  // Katalog produk menggunakan Map dan Record.
  final Map<String, ({String nama, String kategori, int harga})> katalog = {
    'P01': (nama: 'Kopi Sidikalang 250 g', kategori: 'Kopi', harga: 45000),
    'P02': (nama: 'Kopi Gayo 250 g', kategori: 'Kopi', harga: 55000),
    'P03': (nama: 'Teh Kayu Aro 100 g', kategori: 'Teh', harga: 25000),
    'P04': (nama: 'Gula Aren 500 g', kategori: 'Pemanis', harga: 30000),
    'P05': (nama: 'Bolu Meranti', kategori: 'Makanan', harga: 80000),
  };

  print('==============================================');
  print('       $namaToko');
  print('==============================================');

  print('\nDAFTAR PRODUK');
  print('----------------------------------------------');
  print('${'Kode'.padRight(8)}${'Nama Produk'.padRight(25)}Harga');
  print('----------------------------------------------');

  katalog.forEach((kode, produk) {
    print('${kode.padRight(8)}${produk.nama.padRight(25)}Rp${produk.harga}');
  });

  print('----------------------------------------------');

  stdout.write('\nMasukkan pesanan (contoh: P01x2, P03x1): ');
  var input = stdin.readLineSync() ?? '';

  // Memisahkan pesanan berdasarkan tanda koma.
  final List<String> daftarPesanan = input.split(',');

  final List<({String kode, String nama, int jumlah, int subtotal})>
  pesananValid = [];

  final List<String> pesananDitolak = [];

  for (final String item in daftarPesanan) {
    final String teks = item.trim();

    if (teks.isEmpty) {
      continue;
    }

    final List<String> bagian = teks.split('x');

    if (bagian.length != 2) {
      pesananDitolak.add(teks);
      continue;
    }

    final String kode = bagian[0].trim().toUpperCase();
    final int? jumlah = int.tryParse(bagian[1].trim());

    // Validasi kode produk dan jumlah.
    final produk = katalog[kode];

    if (produk == null || jumlah == null || jumlah <= 0) {
      pesananDitolak.add(teks);
      continue;
    }

    pesananValid.add((
      kode: kode,
      nama: produk.nama,
      jumlah: jumlah,
      subtotal: produk.harga * jumlah,
    ));
  }

  // Menghitung total menggunakan map dan fold.
  final int total = pesananValid
      .map((item) => item.subtotal)
      .fold(0, (nilai, subtotal) => nilai + subtotal);

  // Diskon 10% jika total minimal Rp100.000.
  final int diskon = total >= 100000 ? (total * 0.10).round() : 0;

  final int totalBayar = total - diskon;

  // Mengambil kategori produk yang dibeli menggunakan Set.
  final Set<String> kategoriDibeli = pesananValid
      .map((item) => katalog[item.kode]!.kategori)
      .toSet();

  // Menampilkan struk.
  print('\n\n==============================================');
  print('                 STRUK BELANJA');
  print('==============================================');

  if (pesananValid.isEmpty) {
    print('Tidak ada produk valid yang dibeli.');
  } else {
    for (final item in pesananValid) {
      print('\n${item.nama}');
      print('${item.kode} x ${item.jumlah} = Rp${item.subtotal}');
    }
  }

  print('\n----------------------------------------------');
  print('Total Belanja : Rp$total');
  print('Diskon 10%    : Rp$diskon');
  print('Total Bayar   : Rp$totalBayar');
  print('----------------------------------------------');

  print('Kategori Dibeli:');
  if (kategoriDibeli.isEmpty) {
    print('- Tidak ada');
  } else {
    for (final kategori in kategoriDibeli) {
      print('- $kategori');
    }
  }

  print('\nPesanan Ditolak:');
  if (pesananDitolak.isEmpty) {
    print('- Tidak ada');
  } else {
    for (final item in pesananDitolak) {
      print('- $item');
    }
  }

  print('\n==============================================');
  print('       TERIMA KASIH TELAH BERBELANJA');
  print('==============================================');
}
