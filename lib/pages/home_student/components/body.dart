import 'package:flutter/material.dart';
import 'package:flutter_application/pages/home_student/components/bannerBiologia.dart';
import 'package:flutter_application/pages/home_student/components/bannerFisica.dart';
import 'package:flutter_application/pages/home_student/components/bannerQuimica.dart';
import 'package:flutter_application/size_config.dart';


class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
          _buildSection(
            title: 'Curso de Biología',
            icon: Icons.category,
            banner: const BannerBiologia(),
          ),
          _buildSection(
            title: 'Curso de Química',
            icon: Icons.category,
            banner: const BannerQuimica(),
          ),
          _buildSection(
            title: 'Curso de Física',
            icon: Icons.category,
            banner: const BannerFisica(),
          ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget banner,
  }) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 20),
              Icon(
                icon,
                color: Colors.black,
                size: getProportionateScreenWidth(20),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: getProportionateScreenWidth(16),
                  ),
                ),
              ),
            ],
          ),
          banner,
        ],
      ),
    );
  }}

