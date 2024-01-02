import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    home: BlogPage(),
  ));
}

class Blog {
  String? idInformation;
  String title;
  String type;
  String creationDate;
  String dateDePrevention;
  String region;
  String pays;
  String statement;
  String description;

  Blog({
    required this.title,
    required this.type,
    required this.creationDate,
    required this.dateDePrevention,
    required this.region,
    required this.pays,
    required this.statement,
    required this.description,
    this.idInformation,
  });
}

class BlogPage extends StatefulWidget {
  const BlogPage({Key? key}) : super(key: key);

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  late List<Blog> blogs;
  late List<Blog> filteredBlogs;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse("http://localhost:9090/information"));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        blogs = data.map((item) => Blog(
          title: item['titre'],
          type: item['typeCatastrophe'],
          creationDate: item['createdAt'],
          dateDePrevention: item['dateDePrevention'],
          region: item['region'],
          pays: item['pays'],
          statement: item['etat'],
          description: item['descriptionInformation'],
          idInformation: item['_id'],
        )).toList();
        filteredBlogs = List.from(blogs);
      });
    } else {
      print("Failed to load data: ${response.statusCode}");
    }
  }

  void _filterBlogs(String query) {
    setState(() {
      filteredBlogs = blogs
          .where((blog) => blog.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Page'),
      ),
      body: Stack(
        children: [
          Image.network(
            "assets/images/backgroun2.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: Colors.lightBlue.withOpacity(0.5),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filterBlogs,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.fromLTRB(16, 80, 16, 16),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Title', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                    Text('Type of Catastrophe', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                    Text('Creation Date', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                    Text('Actions', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
                const SizedBox(height: 8),
                if (filteredBlogs != null)
                  for (Blog blog in filteredBlogs)
                    _buildTableRow(blog, context),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(Blog blog, BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(blog.title, style: TextStyle(color: Colors.black)),
            Text(blog.type, style: TextStyle(color: Colors.black)),
            Text(blog.creationDate, style: TextStyle(color: Colors.black)),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    _showDetailsDialog(context, blog);
                  },
                  icon: Icon(Icons.details, color: Colors.blue),
                ),
                IconButton(
                  onPressed: () {
                    _showCommentsDialog(context, blog);
                  },
                  icon: Icon(Icons.comment, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label :',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, Blog blog) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            'Détails du Blog',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Titre', blog.title),
              _buildDetailRow('Type de Catastrophe', blog.type),
              _buildDetailRow('Date de Prevention', blog.dateDePrevention),
              _buildDetailRow('Region', blog.region),
              _buildDetailRow('Pays', blog.pays),
              _buildDetailRow('Statement', blog.statement),
              _buildDetailRow('Description', blog.description),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                primary: Colors.black,
              ),
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

 void _showCommentsDialog(BuildContext context, Blog blog) async {
  final url = 'http://127.0.0.1:9090/commentairesinformation?idInformation=${blog.idInformation}';


    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> comments = (jsonDecode(response.body) as List)
            .map((comment) => {'comment': comment['descriptionCommentaire'], 'id': comment['_id']})
            .toList();

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Commentaires pour ${blog.title}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Divider(
                      color: Colors.black,
                      height: 1,
                    ),
                    const SizedBox(height: 8),
                    for (Map<String, dynamic> comment in comments)
                      _buildCommentRow(comment),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Fermer',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        // La requête a échoué
        print('Échec de la requête : ${response.statusCode}');
      }
    } catch (error) {
      // Une erreur s'est produite lors de la requête
      print('Erreur lors de la requête : $error');
    }
  }

  Widget _buildCommentRow(Map<String, dynamic> comment) {
    final commentText = comment['comment'] ?? '';
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.account_circle, size: 40, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              commentText,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
