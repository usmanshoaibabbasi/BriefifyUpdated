import 'package:briefify/data/constants.dart';
import 'package:flutter/material.dart';

Widget AccountSectionItems({
  context,
  ontapAccountSectionItems,
  widgetpass,
  title,
}) {
  return GestureDetector(
    onTap: ontapAccountSectionItems,
    child: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Row(
          children: [
            widgetpass,
            const SizedBox(width: 20,),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: kSecondaryTextColor,
                      fontSize: 16,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 36,
                    color: kTextColorLightGrey,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
