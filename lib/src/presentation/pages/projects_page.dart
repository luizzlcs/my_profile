import 'package:flutter/material.dart';
import 'package:portfolio_tech/locator.dart';
import 'package:portfolio_tech/src/constants/app_image.dart';
import 'package:portfolio_tech/src/domain/entities/project.dart';
import 'package:portfolio_tech/src/domain/repositories/project_repository.dart';
import 'package:portfolio_tech/src/presentation/widgets/button_link.dart';

class ProjectsPage extends StatelessWidget {
  ProjectsPage({super.key});

  final ProjectRepository _repository = getIt<ProjectRepository>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final larguraDaTela = mediaQuery.size.width;

    debugPrint('larguraDaTela + ${larguraDaTela.toString()}');

    return Scaffold(
      appBar: AppBar(title: Text("Projetos")),
      body: FutureBuilder<List<Project>>(
        future: _repository.getProjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Erro ao carregar projetos: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Nenhum projeto encontrado"));
          }

          final projects = snapshot.data!;

          return GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: larguraDaTela > 600 ? 3 : 1, //colunas
              crossAxisSpacing: 8, // Espaçamento horizontal entre os itens
              mainAxisSpacing: 16, // Espaçamento vertical entre os itens
              childAspectRatio: 1.0, // Proporção de aspecto dos itens
            ),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return ProjectCard(project: project);
            },
          );
        },
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Container(
      decoration: BoxDecoration(
      color: Colors.amber,
      borderRadius: BorderRadius.all(Radius.circular(10))

      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisSize: MainAxisSize.min, // Evita que a Column expanda seus filhos
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagem do projeto (com altura fixa)
            Container(
              height:210, // Altura fixa para a imagem
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  project.imageUrl,
                  fit: BoxFit.fill, // Cobrir o espaço disponível
                ),
              ),
            ),
            Divider(),
            // Nome e tipo do projeto
            SelectableText(
              project.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SelectableText('✅ ${project.type}'),
            // Descrição do projeto
            Expanded(
              child: SingleChildScrollView(
                child: SelectableText(
                  project.description,
                  style: TextStyle(fontSize: 10.5),
                ),
              ),
            ),
            // Links do site e GitHub
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: project.siteUrl.isNotEmpty,
                  child: ButtonLink(
                    icon: Icons.link_sharp,
                    url: project.siteUrl,
                    useIcon: false,
                    whidth: 40,
                  ),
                ),
                // SizedBox(width: 8), // Espaçamento entre os botões
                ButtonLink(
                  url: project.githubUrl,
                  useIcon: true,
                  image: AppImage.gitHub,
                  whidth: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
}
