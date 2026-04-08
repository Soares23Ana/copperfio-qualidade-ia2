import 'package:flutter/material.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  static const List<_CatalogItem> _items = [
    _CatalogItem(
      title: 'Cabo de Cobre Triplex 1x25mm²',
      subtitle: 'Alta condutividade, isolamento XLPE',
      imageUrl: 'https://i.imgur.com/BhG9fbd.png',
      pdfUrl: 'https://example.com/fichas/cabo_cobre_triplex_1x25.pdf',
    ),
    _CatalogItem(
      title: 'Cabo de Alumínio 3x70mm²',
      subtitle: 'Excelente para linhas aéreas',
      imageUrl: 'https://i.imgur.com/VKucmbG.png',
      pdfUrl: 'https://example.com/fichas/cabo_aluminio_3x70.pdf',
    ),
    _CatalogItem(
      title: 'Cabo Multiplex Cobre 4x25mm²',
      subtitle: 'Uso industrial e instalações comerciais',
      imageUrl: 'https://i.imgur.com/I9ZTQKl.png',
      pdfUrl: 'https://example.com/fichas/cabo_multiplex_4x25.pdf',
    ),
    _CatalogItem(
      title: 'Cabo de Aço Alumínio 1x240mm²',
      subtitle: 'Alta resistência mecânica para redes distribuídas',
      imageUrl: 'https://i.imgur.com/6fcG6xZ.png',
      pdfUrl: 'https://example.com/fichas/cabo_aco_aluminio_1x240.pdf',
    ),
    _CatalogItem(
      title: 'Cabo de Cobre Isolado 2x16mm²',
      subtitle: 'Excelente para instalação residencial',
      imageUrl: 'https://i.imgur.com/3pDwqCJ.png',
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
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _items[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.imageUrl,
                          width: 84,
                          height: 84,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) =>
                              const Icon(Icons.image_not_supported, size: 84),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.subtitle,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _baixarFichaTecnica(context, item),
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('Baixar Ficha Técnica (PDF)'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Função de “Fazer pedido” ativada.')),
          );
        },
        icon: const Icon(Icons.shopping_cart),
        label: const Text('Fazer pedido'),
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
