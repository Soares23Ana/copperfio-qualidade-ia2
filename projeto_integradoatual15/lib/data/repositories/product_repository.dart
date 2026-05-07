import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final snapshot = await _firestore.collection('products').get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc))
            .toList();
      }
    } catch (_) {
      // Se a coleção não existir ou ocorrer erro, usamos fallback local.
    }

    return _localProducts;
  }

  static const List<ProductModel> _localProducts = [
    ProductModel(
      title: 'Cabos Copperfio de Alumínio Nu com Alma de Aço - CAA',
      subtitle: 'ACRS – Aluminium Conductor Steel Reinforced',
      description:
          'Os Cabos de Alumínio nu com alma de aço – CAA se destinam a transmissão de energia elétrica onde se requer uma maior resistência mecânica.\n\nSão constituídos por um núcleo de aço galvanizado, denominado alma de aço, e sobre ele fios de alumínio liga 1350, têmpera H 19, encordoados de forma concêntrica.\n\nA alma de aço pode ser constituída por um ou mais fios de aço e a galvanização pode ser classe A, B ou C.',
      specs: [
        '5118 – Fios de Alumínio 1350 nus, de seção circular, para fins elétricos.',
        '6756 - Fios de aço zincados para alma de cabos de alumínio e alumínio-liga.',
        '7270 - Cabos de alumínio nus com alma de aço zincado para linhas aéreas.',
      ],
      imageUrl: 'https://www.copperfio.com.br/img/produtos/01g.jpg',
      pdfUrl:
          'assets/fichasTecnicas/Cabos Copperfio de Alumínio Nu COM Alma de Aço.pdf',
    ),
    ProductModel(
      title: 'Cabos Copperfio de Alumínio Nu com Alma de Aço - CAA',
      subtitle: 'ACRS – Aluminium Conductor Steel Reinforced',
      description:
          'Os Cabos de Alumínio nu com alma de aço – CAA se destinam a transmissão de energia elétrica onde se requer uma maior resistência mecânica.\n\nSão constituídos por um núcleo de aço galvanizado, denominado alma de aço, e sobre ele fios de alumínio liga 1350, têmpera H 19, encordoados de forma concêntrica.\n\nA alma de aço pode ser constituída por um ou mais fios de aço e a galvanização pode ser classe A, B ou C.',
      specs: [
        '5118 – Fios de Alumínio 1350 nus, de seção circular, para fins elétricos.',
        '6756 - Fios de aço zincados para alma de cabos de alumínio e alumínio-liga.',
        '7270 - Cabos de alumínio nus com alma de aço zincado para linhas aéreas.',
      ],
      imageUrl: 'https://www.copperfio.com.br/img/produtos/02g.jpg',
      pdfUrl:
          'assets/fichasTecnicas/Cabos Copperfio de Alumínio Nu COM Alma de Aço.pdf',
    ),
    ProductModel(
      title: 'Cabos Copperfio de Alumínio Nu com Alma de Aço Extra Forte',
      subtitle: 'Uso industrial e linhas de distribuição',
      description:
          'Os cabos de alumínio nu extra forte são formados por uma ou mais coroas de fios de alumínio liga 1350 – H 19, encordoados concentricamente sobre uma alma de aço.\n\nSão utilizados em linhas de transmissão aéreas e também em linhas de distribuição primárias e secundárias que requerem reforço mecânico.',
      specs: [
        '7270 – Cabos de Alumínio nu com alma de aço zincado para linhas aéreas - Especificação.',
        '6756 – Fios de Aço zincados para alma de cabos de alumínio e alumínio – liga.',
      ],
      imageUrl: 'https://www.copperfio.com.br/img/produtos/03g.jpg',
      pdfUrl:
          'assets/fichasTecnicas/Cabos Copperfio de Alumínio- Alma de Aço Extra Forte.pdf',
    ),
    ProductModel(
      title: 'Cabos Copperfio de Alumínio Nu - Liga 6201',
      subtitle: 'AAAC – All Aluminium Alloy Conductor',
      description:
          'A liga de alumínio 6201 é uma liga com Magnésio e Silício com dureza T 81 que lhe confere aproximadamente o dobro da resistência mecânica de alumínio liga 1350 – H19.\n\nOs cabos de alumínio nu com liga 6201 foram desenvolvidos para substituir, em determinadas situações, os cabos de alumínio com alma de aço acarretando menos custo nos projetos de linhas de transmissão e distribuição.\n\nEm determinados projetos a liga 6201 pode ser utilizada em associação com alumínio liga 1350 – H 19.',
      specs: [
        '10298 – Cabos de Alumínio-magnésio-silício, nus, para linhas aéreas – Especificação.',
      ],
      imageUrl: 'https://www.copperfio.com.br/img/produtos/04g.jpg',
      pdfUrl:
          'assets/fichasTecnicas/Cabos Copperfio de Alumínio Nu-LIGA 6201.pdf',
    ),
    ProductModel(
      title: 'Fios Copperfio de Alumínio Nu - Liga 1350',
      subtitle: 'Fios de alumínio para grampos e rebites',
      description:
          'Os fios de alumínio nu são obtidos por trefilação do vergalhão e atendem os segmentos de grampos, rebites entre outros. Os fios na Liga 1350 podem ser fornecidos em rolos ou bobinas, nas durezas "Duro", "3/4 Duro", "1/2 Duro" ou "Mole" conforme NBR 5118.',
      specs: [
        '5118 – Fios de alumínio nus, de seção circular, para fins elétricos.',
      ],
      imageUrl: 'https://www.copperfio.com.br/img/produtos/05g.jpg',
      pdfUrl: 'assets/fichasTecnicas/Fios Copperfio de Alumínio Nu-1350.pdf',
    ),
    ProductModel(
      title: 'Fios Copperfio de Alumínio Nu - Liga 6201 Têmpera T 81',
      subtitle: 'Fios conforme NBR 5285',
      description:
          'Os fios de alumínio nu são obtidos por trefilação do vergalhão e atendem os segmentos de alça pré-formada, cerca elétrica entre outros.\n\nSão produzidos de acordo com a NBR 5285 e podem ser fornecidos em rolos ou bobinas.',
      specs: [
        '5285 – Fios de alumínio-magnésio-silício, têmpera T81, nus, de seção circular, para fins elétricos - Especificação.',
      ],
      imageUrl: 'https://www.copperfio.com.br/img/produtos/06g.jpg',
      pdfUrl: 'assets/fichasTecnicas/Fios Copperfio de Alumínio Nu-6201.pdf',
    ),
    ProductModel(
      title:
          'Cabos Multiplex Copperfio para Baixa Tensão 06/1 kV Isolados com PE/XLPE - Duplex',
      subtitle: 'Multiplex para até 1.000 V',
      description:
          'Os Cabos multiplex Copperfio são formados pela reunião de 1, 2 ou 3 condutores fase em torno de um condutor neutro, e são utilizados em circuitos de alimentação e/ou distribuição de energia elétrica em tensões de até 1.000 V entre fases, ou 600 V entre fase e neutro.\n\nOs condutores fase dos cabos multiplex Copperfio são identificados através de gravação sobre a isolação com tinta indelével ou isolados nas cores pretas, vermelha e cinza. Nos cabos multiplex Copperfio com neutro isolado a identificação deste é feita na cor azul claro.',
      specs: [
        '8182 – Cabos de potência multiplexados autos sustentados com isolação extrudada de Polietileno Termoplástico (PE) ou Polietileno Termofixo (XLPE), para tensões até 0,6/1kV.',
      ],
      imageUrl: 'https://www.copperfio.com.br/img/produtos/07g.jpg',
      pdfUrl:
          'assets/fichasTecnicas/Cabos Multiplex Copperfio para Baixa Tensão 06-DUPLEX.pdf',
    ),
    ProductModel(
      title:
          'Cabos Multiplex Copperfio para Baixa Tensão 06/1 kV Isolados com PE/XLPE - Triplex',
      subtitle: 'Multiplex para até 1.000 V',
      description:
          'Os Cabos multiplex Copperfio são formados pela reunião de 1, 2 ou 3 condutores fase em torno de um condutor neutro, e são utilizados em circuitos de alimentação e/ou distribuição de energia elétrica em tensões de até 1.000 V entre fases, ou 600 V entre fase e neutro.\n\nOs condutores fase dos cabos multiplex Copperfio são identificados através de gravação sobre a isolação com tinta indelével ou isolados nas cores pretas, vermelha e cinza. Nos cabos multiplex Copperfio com neutro isolado a identificação deste é feita na cor azul claro.',
      specs: [
        '8182 – Cabos de potência multiplexados autossustentados com isolação extrudada de PE ou XLPE, para tensões até 0,6/1 kV - Requisitos de desempenho.',
      ],
      imageUrl: 'https://www.copperfio.com.br/img/produtos/08g.jpg',
      pdfUrl: 'assets/fichasTecnicas/Cabos Multiplex Copperfio-TRIPLEX.pdf',
    ),
    ProductModel(
      title:
          'Cabos Multiplex Copperfio para Baixa Tensão 06/1 kV Isolados com PE/XLPE - Quadruplex',
      subtitle: 'Multiplex para até 1.000 V',
      description:
          'Os Cabos multiplex Copperfio são formados pela reunião de 1, 2 ou 3 condutores fase em torno de um condutor neutro, e são utilizados em circuitos de alimentação e/ou distribuição de energia elétrica em tensões de até 1.000 V entre fases, ou 600 V entre fase e neutro.\n\nOs condutores fase dos cabos multiplex Copperfio são identificados através de gravação sobre a isolação com tinta indelével ou isolados nas cores pretas, vermelha e cinza. Nos cabos multiplex Copperfio com neutro isolado a identificação deste é feita na cor azul claro.',
      specs: [
        '8182 – Cabos de potência multiplexados autossustentados com isolação extrudada de PE ou XLPE, para tensões até 0,6/1 kV - Requisitos de desempenho.',
      ],
      imageUrl: 'https://www.copperfio.com.br/img/produtos/09g.jpg',
      pdfUrl: 'assets/fichasTecnicas/Cabos Multiplex Copperfio-QUADRUPLEX.pdf',
    ),
    ProductModel(
      title: 'Cabos Copperfio de Alumínio 06/1 kV Isolados com XLPE',
      subtitle: 'Cabos isolados para 600/1000 V',
      description:
          'Os cabos de alumínio isolados com XLPE para tensão 06/1 kV sem cobertura são constituídos por um condutor compactado formado por fios de alumínio liga 1350.\n\nOs cabos de alumínio isolados são utilizados em circuitos de alimentação e distribuição de energia elétrica em prédios industriais e comerciais.',
      specs: [
        'NM 280 – Condutores de cabos isolados (IEC 60228, MOD).',
        '7285 - Cabos de potência com isolação extrudada de polietileno termofixo (XLPE) para tensão de 0,6/1 kV - Sem cobertura.',
      ],
      imageUrl: 'https://www.copperfio.com.br/img/produtos/10g.jpg',
      pdfUrl: 'assets/fichasTecnicas/Cabos Copperfio de Alumínio 06-UNI.pdf',
    ),
    ProductModel(
      title:
          'Cabos Copperfio de Alumínio Protegido 8,7/15 kV Cobertos com XLPE',
      subtitle: 'Protegido para até 15 kV',
      description:
          'Os cabos de alumínio protegido coberto com XLPE para tensão até 15 kV são constituídos por um condutor compactado formado por fios de alumínio liga 1350 podendo ser bloqueado ou não.\n\nA proteção é feita com Polietileno Termofixo (XLPE) na cor preta ou cinza, resistente aos raios ultravioleta e ao trilhamento elétrico (antitracking).\n\nOs cabos protegidos cobertos com XLPE para tensão até 15kV são utilizados em linhas de distribuição primária de energia elétrica em situações onde se requer segurança.',
      specs: [
        '11873 – Cabos cobertos com material polimérico para redes de distribuição aérea de energia elétrica fixados em espaçadores, em tensões de 13,8 kV a 34,5 kV.',
      ],
      imageUrl: 'https://www.copperfio.com.br/img/produtos/11g.jpg',
      pdfUrl:
          'assets/fichasTecnicas/Cabos Copperfio de Alumínio PROTEGIDO 8.pdf',
    ),
  ];
}
