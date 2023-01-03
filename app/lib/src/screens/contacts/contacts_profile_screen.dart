import 'package:app/src/features/query_contacts/query_contacts.dart';
import 'package:app/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ContactsProfileScreen extends StatefulWidget {
  final QueriedContacts contacts;

  const ContactsProfileScreen({Key? key, required this.contacts})
      : super(key: key);

  @override
  ContactProfileScreenState createState() => ContactProfileScreenState();
}

class ContactProfileScreenState extends State<ContactsProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: CloseButton(color: Theme.of(context).primaryColor),
            elevation: 0),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.fromLTRB(1, 10, 15, 20),
                  child: Row(children: [
                    const SizedBox(width: 20),
                    UserAvatar(
                      id: widget.contacts.id,
                      name: widget.contacts.name,
                      avatarUrl: widget.contacts.avatarUrl,
                      radius: 34,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.contacts.name,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'id：${widget.contacts.id}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ])),
              InkWell(
                  child: const LabelCard(
                    label: 'Add to Contacts',
                  ),
                  onTap: () {
                    String tapTip =
                        'request has been sent, please wait for agree';
                    // try {
                    //   final pubsubRepository = context.read<PubsubRepository>();
                    //   await pubsubRepository.pub(
                    //       accountId: account.id,
                    //       targetId: widget._contact.id,
                    //       event: kAddContactReq,
                    //       info: '{}',
                    //       state: kPublicationStateCreate);
                    // } catch (e) {
                    //   tapTip = e.toString();
                    // }
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(tapTip)));
                  }),
            ]));
  }
}
