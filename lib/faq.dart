import 'package:flutter/material.dart';
import 'package:your_eyes/constants/colors.dart';

class UpdatesAndFAQ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text('Updates & FAQ',style: Theme.of(context).textTheme.labelMedium,),
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Latest Updates:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  _buildUpdateCard(context,'Version 2.0', 'Improved app experience'),
                  _buildUpdateCard(context,'Version 1.5', 'Added support for app recognition'),

                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'FAQs:', style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  _buildFAQ(context,'How do I start a new recognition?', 'To start a new recognition, simply tap the New recognition button on the home screen.'),
                  _buildFAQ(context,'Is Your Eyes App available on iOS?', 'Yes, Your Eyes App is available on both Android and iOS platforms.'),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateCard(BuildContext context ,String version, String description) {
    return Card(
      color: Theme.of(context).secondaryHeaderColor,
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ListTile(
        title: Text(version,style: Theme.of(context).textTheme.labelMedium ,),
        subtitle: Text(description,style:  Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5),
        ),),
      ),
    );
  }

  Widget _buildFAQ(BuildContext context , String question, String answer) {
    return Card(
      color: Theme.of(context).secondaryHeaderColor,
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ExpansionTile(
        iconColor: Theme.of(context).iconTheme.color,
        collapsedIconColor:Theme.of(context).iconTheme.color ,
        title: Text(question,style: Theme.of(context).textTheme.labelMedium ,),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(answer,style:  Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5),
            ),),
          ),
        ],
      ),
    );
  }
}


