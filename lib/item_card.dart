import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemCard extends StatelessWidget {
  final String glucose;
  final int carbo;

  final Function onDelete;

  const ItemCard(this.glucose, this.carbo, {this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue[900])),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(glucose,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 16)),
              ),
              Text(
                "$carbo ",
                style: GoogleFonts.poppins(),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                height: 40,
                width: 60,
                child: RaisedButton(
                    shape: const CircleBorder(),
                    color: Colors.red[900],
                    child: const Center(
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        )),
                    onPressed: () {
                      if (onDelete != null) onDelete();
                    }),
              )
            ],
          )
        ],
      ),
    );
  }
}