import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:touristop/theme/app_spacing.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key, required this.user}) : super(key: key);

  final User? user;

  @override
  Widget build(BuildContext context) {
    final userHistory = FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('spots')
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.xxl,
            horizontal: AppSpacing.base,
          ),
          child: user != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'History',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.base,
                    ),
                    Expanded(
                      child: StreamBuilder<List<Map<String, dynamic>>>(
                        stream: userHistory,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: LoadingIndicator(
                                  indicatorType: Indicator.ballRotateChase,
                                  colors: AppColors.cbToSlime,
                                ),
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text('Something went wrong!'),
                            );
                          }

                          final data = snapshot.requireData;

                          return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        bottom: AppSpacing.small),
                                    height: 150,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color.fromRGBO(93, 107, 230, 1),
                                          Color.fromRGBO(93, 230, 197, 1),
                                        ],
                                      ),
                                      image: DecorationImage(
                                        image:
                                            NetworkImage(data[index]['image']),
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(
                                          const Color.fromARGB(255, 0, 0, 0)
                                              .withOpacity(0.6),
                                          BlendMode.darken,
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.all(AppSpacing.base),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            DateFormat('EEE, MMM d, yy')
                                                .format(
                                                  DateUtils.dateOnly(
                                                    DateTime
                                                        .fromMicrosecondsSinceEpoch(
                                                      data[index]['date']
                                                          .microsecondsSinceEpoch,
                                                    ),
                                                  ),
                                                )
                                                .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: AppSpacing.small,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 320,
                                                child: Text(
                                                  data[index]['name'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                          );
                        },
                      ),
                    )
                  ],
                )
              : const Center(
                  child: Text('No history for this user'),
                ),
        ),
      ),
    );
  }
}
