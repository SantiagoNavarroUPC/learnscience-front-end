import 'package:flutter/material.dart';
import 'package:flutter_application/pages/home/components/bannerBiologia.dart';
import 'package:flutter_application/pages/home/components/bannerFisica.dart';
import 'package:flutter_application/pages/home/components/bannerQuimica.dart';
import 'package:flutter_svg/svg.dart';


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
            iconPath: 'assets/icons/biologia.svg',
            banner: const BannerBiologia(),
          ),
          _buildSection(
            title: 'Curso de Química',
            iconPath: 'assets/icons/quimica.svg',
            banner: const BannerQuimica(),
          ),
          _buildSection(
            title: 'Curso de Física',
            iconPath: 'assets/icons/fisica.svg',
            banner: const BannerFisica(),
          ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String iconPath,
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
            children: [
              SizedBox(width: 10),
              SvgPicture.asset(
                iconPath,
                width: 25,
                height: 25,
              ),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          banner,
        ],
      ),
    );
  }}

