import 'package:flutter/material.dart';
import 'package:concon/models/Con.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class TimeTable extends StatefulWidget {
  const TimeTable({Key? key}) : super(key: key);

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  List<Con> _cons = [];
  List<Con> _likedCons = [];

  @override
  void initState() {
    super.initState();
    fetchCons();
  }

  Future<void> fetchCons() async {
    try {
      var dio = Dio(BaseOptions(responseType: ResponseType.plain));
      var response = await dio.get('https://10beb5aa-fc01-42fe-9345-cdf808eaac56-00-3r6qaewvaakyh.pike.replit.dev/produtos');

      setState(() {
        var list = jsonDecode(response.data.toString()) as List<dynamic>;
        _cons = list.map((item) => Con.fromJson(item)).toList();
      });
    } catch (error) {
      print('Error fetching cons: $error');
    }
  }

  void _toggleLikeStatus(Con con) {
    setState(() {
      if (_likedCons.contains(con)) {
        _likedCons.remove(con);
      } else {
        _likedCons.add(con);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _cons.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _cons.length,
                  itemBuilder: (context, index) {
                    var con = _cons[index];
                    var imageURL = con.image ?? '';
                    return ListTile(
                      title: Text(
                        con.concert_name ?? '',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        con.event_date != null ? 'date: ${con.event_date}' : '',
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: imageURL.isNotEmpty
                          ? SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.network(
                                imageURL,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                  return const Icon(Icons.error, color: Color.fromARGB(255, 255, 247, 1));
                                },
                              ),
                            )
                          : const SizedBox.shrink(),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => ConDetailDialog(con: con, onLikeToggle: _toggleLikeStatus),
                        );
                      },
                    );
                  },
                ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LikedPage(likedCons: _likedCons),
              ),
            );
          },
          child: Text('LIKED (${_likedCons.length})'),
        ),
      ],
    );
  }
}

class ConDetailDialog extends StatefulWidget {
  final Con con;
  final Function(Con) onLikeToggle;

  const ConDetailDialog({Key? key, required this.con, required this.onLikeToggle}) : super(key: key);

  @override
  _ConDetailDialogState createState() => _ConDetailDialogState();
}

class _ConDetailDialogState extends State<ConDetailDialog> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.con.concert_name ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text('Date: ${widget.con.event_date ?? ''}', style: TextStyle(color: Colors.black)),
            const SizedBox(height: 8),
            Text('Time: ${widget.con.event_time ?? ''}', style: TextStyle(color: Colors.black)),
            const SizedBox(height: 8),
            Text('Concert ticket price: ${widget.con.price_ticket ?? ''}', style: TextStyle(color: Colors.black)),
            const SizedBox(height: 8),
            Text('Ways to buy tickets: ${widget.con.ticket ?? ''}', style: TextStyle(color: Colors.black)),
            const SizedBox(height: 8),
            Text('Concert venue: ${widget.con.venue ?? ''}', style: TextStyle(color: Colors.black)),
            const SizedBox(height: 8),
            Text('List of artists: ${widget.con.name_art ?? ''}', style: TextStyle(color: Colors.black)),
            const SizedBox(height: 8),
            Image.network(
              widget.con.image ?? '',
              height: 350,
              width: 350,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return Icon(Icons.error, color: Color.fromARGB(255, 243, 8, 8));
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isLiked = !_isLiked;
                    });
                    widget.onLikeToggle(widget.con);
                  },
                  icon: Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_border,
                    color: _isLiked ? Colors.red : null,
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LikedPage extends StatelessWidget {
  final List<Con> likedCons;

  const LikedPage({Key? key, required this.likedCons}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liked Concerts'),
      ),
      body: ListView.builder(
        itemCount: likedCons.length,
        itemBuilder: (context, index) {
          var con = likedCons[index];
          return ListTile(
            title: Text(con.concert_name ?? ''),
            subtitle: Text(con.event_date ?? ''),
            trailing: Icon(Icons.favorite, color: Colors.red),
          );
        },
      ),
    );
  }
}