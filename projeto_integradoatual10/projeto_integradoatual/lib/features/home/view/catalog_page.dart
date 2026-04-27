import 'package:flutter/material.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  static const List<_CatalogItem> _items = [
    _CatalogItem(
      title: 'Cabos Copperfio de Alumínio Nu com Alma de Aço - CAA',
      subtitle: 'Alta condutividade, isolamento XLPE',
      imageUrl: 'https://www.copperfio.com.br/img/produtos/01p.jpg',
      pdfUrl: 'https://example.com/fichas/cabo_cobre_triplex_1x25.pdf',
    ),
    _CatalogItem(
      title: 'Cabos Copperfio de Alumínio Nu sem Alma de Aço - CA',
      subtitle: 'Excelente para linhas aéreas',
      imageUrl: 'https://www.copperfio.com.br/img/produtos/02p.jpg',
      pdfUrl: 'https://example.com/fichas/cabo_aluminio_3x70.pdf',
    ),
    _CatalogItem(
      title: 'Cabos Copperfio de Alumínio Nu com Alma de Aço Extra Forte',
      subtitle: 'Uso industrial e instalações comerciais',
      imageUrl: 'https://www.copperfio.com.br/img/produtos/03p.jpg',
      pdfUrl: 'https://example.com/fichas/cabo_multiplex_4x25.pdf',
    ),
    _CatalogItem(
      title: 'Fios Copperfio de Alumínio Nu - Liga 1350²',
      subtitle: 'Alta resistência mecânica para redes distribuídas',
      imageUrl: 'https://www.copperfio.com.br/img/produtos/05p.jpg',
      pdfUrl: 'https://example.com/fichas/cabo_aco_aluminio_1x240.pdf',
    ),
    _CatalogItem(
      title:
          'Cabos Multiplex Copperfio para Baixa Tensão 06/1 kV Isolados com PE/XLPE - Quadruplex',
      subtitle: 'Excelente para instalação residencial',
      imageUrl: 'https://www.copperfio.com.br/img/produtos/09p.jpg',
      pdfUrl: 'https://example.com/fichas/cabo_cobre_isolado_2x16.pdf',
    ),
  ];

  void _baixarFichaTecnica(BuildContext context, _CatalogItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Iniciando download de: ${item.title}')),
    );

    // TODO: implemente o download real usando url_launcher / dio / open_file.
    debugPrint('Baixando PDF: ${item.pdfUrl}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo & Fichas Técnicas'),
        centerTitle: true,
        backgroundColor: const Color(0xFF9C1818),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: const Color(0xFFF7F2F8),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar por lote ou cliente...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.62,
                ),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFF9C1818).withOpacity(0.16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(18),
                          ),
                          child: SizedBox(
                            height: 100,
                            child: Image.network(
                              item.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stack) =>
                                  Container(
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item.title,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item.subtitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                          child: OutlinedButton.icon(
                            onPressed: () => _baixarFichaTecnica(context, item),
                            icon: const Icon(
                              Icons.picture_as_pdf,
                              color: Color(0xFF9C1818),
                            ),
                            label: const Text(
                              'Baixar Ficha Técnica',
                              style: TextStyle(color: Color(0xFF9C1818)),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF9C1818)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Função de “Fazer pedido” ativada.'),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            label: const Text(
              'Fazer pedido',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9C1818),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CatalogItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String pdfUrl;

  const _CatalogItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.pdfUrl,
  });
}
