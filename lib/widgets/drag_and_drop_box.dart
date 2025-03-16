import 'package:flutter/material.dart';



class DragAndDropBox extends StatefulWidget {
  @override
  _DragAndDropBoxState createState() => _DragAndDropBoxState();
}

class _DragAndDropBoxState extends State<DragAndDropBox> {
  bool isDropped = false;
  bool isDragging = false;

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onAcceptWithDetails: (data) {
        setState(() {
          isDropped = true;
        });
      },
      onWillAcceptWithDetails: (data) {
        return true;
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: isDropped ? Colors.green[100] : Colors.grey[200],
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: isDropped
                ? Icon(Icons.check, size: 48, color: Colors.green)
                : Draggable<String>(
                    data: "icon",
                    feedback: Material(
                      child: Icon(Icons.upload, size: 48, color: Colors.blue),
                    ),
                    childWhenDragging: Container(),
                    onDragStarted: () {
                      setState(() {
                        isDragging = true;
                      });
                    },
                    onDragEnd: (details) {
                      setState(() {
                        isDragging = false;
                      });
                    },
                    child: Icon(
                      Icons.upload,
                      size: 48,
                      color: isDragging ? Colors.blue : Colors.grey,
                    ),
                  ),
          ),
        );
      },
    );
  }
}