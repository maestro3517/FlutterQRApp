import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_app/constants.dart';
import 'package:flutter_qr_app/types/qr.dart';
import 'package:nb_utils/nb_utils.dart';

class QrDataDisplay extends StatefulWidget {
  final Data data;

  QrDataDisplay({Key? key, required this.data}) : super(key: key);

  @override
  QrDataDisplayState createState() => QrDataDisplayState();
}

class QrDataDisplayState extends State<QrDataDisplay> {
  late Map<String, dynamic> data;
  late String dueCalibDate;
  late String dueMsaDate;
  late Map<String, dynamic> modData = {};
  final image =
      "/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAoHCBYVFRgVFRIZGBgaGhgYGBwaGRgaHxwZGRoaGh4YGBocIS4lHB4rHxkZJjgnKy8xNTU1GiQ7QDs0Py80NTEBDAwMDw8PGBIRGDEhGCE0MT00MTE0NDQxNDQ0MTQ3MTE0MTE0MTE0NDQ0NDExNDE0MTExMT80NDExNDQ/ND8xMf/AABEIAMkA+wMBIgACEQEDEQH/xAAcAAEAAgMBAQEAAAAAAAAAAAAABQYCAwQHAQj/xABFEAACAQIDBAcDCgQEBQUAAAABAgADEQQSIQUxQVEGEyJhcYGRMlKhByNCYnKSorHB0RSC0uFDsvDxFSQzU1QWJURzwv/EABkBAQEBAQEBAAAAAAAAAAAAAAABAgMEBf/EAB4RAQEAAgICAwAAAAAAAAAAAAABAhESUQMxBBNB/9oADAMBAAIRAxEAPwD2aIiAiIgIiICIiAiIgIiICIiAiIgIiICIiAiIgIiICIiAiIgIiICIiAiIgIiICIiAiJ8JgfZiTaaHr8vX9pw43HpT1qVACdw3k/ZUa+kCRNccNZgax5AfGVvEbfc/9OnYe9UP/wCF/UiRmJ2jXb2q5A5IFUeti3xk3BdjUb3vymPWH3j8J5pXqM2+o7eLu36yLro99Ff0aTY9gDt7x+H7T6Krdx8p4yteqm56i/zOv6yRwe38Svs4hiOTZXHmSL/GXY9XWvzX01m1XB3GUDB9Mag0q0Q450zY/dbQ+ssOz9tUK+iVLP7jdlx4A6+YjYsMTjWsy7+0Pj/edCVAwuD/AG8ZRsiIgIiICIiAiIgIiICIiAiIgIiICImupUCi5/3MBUcKLmcOIxAALOwVRrqbAeM04zFhAWY9wA3k8FUcTIDE1GqHO+4eynBe/wCs3f6SWjoxe1nfSndF94jtH7IPsjvOvcJGhACSASx3km5P2mM3hCZtyBRckAaC5IA1NgPUgSa37NuUUSd5t4fvMlwg5X7zr+c04nagVWKIWyio246mg9qiBd+fLcr728aTlxL1Xzor3b59Fy3AL5BicO5I3AopUncT5S6iJRqQG8gaE6kDQbz4THKl7Z1vcrbML3C5yLc8pDW5aziOynqh2RLq4xARrj2MTRSpfXh1q29Jy46kaOISmw7eKq1GpWsRpgadI5zw7YPPTWUTK0kbcynduIOjC49RummvstG3oD32F/WY/wDCayMGCBgtRXABFytPCZFFjx60kW85w0A9EKpZglPqqbtfRUw9Fq1Vzf3mZUPHWQfamyAPZYjuOo+Os5K2Ft7a6D6Q3DvvvWSmG2g5yq6XcmkhAsD1tQNUZPBKWVieN51UilQXRr3zEA6EqrFCwB1Kkg2bcRYjfA5sBtivRsGJrU+RPbUfVb6fgfWWrAY9Ky56T34HgQfddTqD3GVSrgimqac1+ifD3TNNPMG6yi2SoNGB3N9V14jkfSFeh0K99Dofz7xOiVrZO1VxCkWyVE9tCdVPBlPFTwMnMNXzaHePiOYlHTERAREQEREBERAREQEREBERAxLWFzIrF4oAF2NlUfD9zN+Ora5R4t+g/X0lfxlXrHyj2KZ+8/7L+ZPKS0a6js7Z309xfcX+o8fSYKtzMm1Npm7hFB0LMcqKWC53sSEBOlzYwPtQqgF7ZmOVATYM9iQma1lvltc8ZEszVmtZnRw9ktlLUzlStQcXsK9NwHB4i4HEzZSpNXc6Zw10fMCoKA3NGuq60qyZsyON/neWHY+EennDhSxcHrBYNVAVVV6gGgcABSRvyA6XsCKpjGbCYrCriFUpXcK1UMdMTTDU0qMMosalMoGGo320FzeMNgURQiKFVQqgAAAKosB4AaTg6SLTNEdbRSr26QRHFwajuqJ6Fr+F5p2zt1qFQItNWRepNQliGtXriguQAWJBJY34C0CYwuDSmiogsqgKo1NgNw1lW2j/AAuIrUcV11RRg2qf4VTIzMwpFVYr2mDrlAW5vLfeUPHYbIzphxXakrGrWV1qkLUXF06l6asPd65rJvAB10MC54HEpWQOhupuNQQQVJVlZWAKsGBBB1BBn2nhEQMqqLMzOwOt2cksTfmSZH9F1IosSpXNiMVUXMCpKVMTUZGIOourA685r2rthqddKKGipZM96rlM93CBEt9I9o313AW1uAg+mVdaVXD0cOgOJxDOq2JAVHC9bWIGmcKFAY7gGtfUHbjdnPSbMKeYZkyqhtcIcmGwq2F1Qa1HY6XJ3i4HZhscKmMXPh6e7FJSqb6i9Q6K4YkeyxckAbsvG+lgdbgi19Dpz7oFTwmNzZUdgxN1VwLCoUBNSoqD2KQbshidT4gt9xeF+kpsw3Hn3HmIxuxXFPMyq5YKKiIciELYJRLn2MMguWAF2tqDcqcdn4u+VHfPnuUe1jUtcu6U1HYoLdVVmOtxqbgsHE+a4qUzkq0/jzRuamWrZG0lxCB17LqbOvFHG8HmPzBlc2thHyl6ftgG3ePdP6f3lV6P9IGoV87k5WOWoO7nbmP3hXtVCrmF+O4jkZukTh6wBDA3VrXPcdzf64EyWlCIiAiIgIiICIiAiIgJrqOFBY7gCT4CbJFbdr5UC+8wHkNT+g84EXjsWyoSPbc2X7TfoBr5TkVAihRw08eZPeZhnz1vq01/G/7KPxTa2pkGzD05D4msazMEGdbimVKu6a2IpYqgwz0WJNxUA00J00MjtWoEp2NrNcEslRktbUO6C9MH3zoJ92Bhsx61gWyjLTZmp1TlIBOSuhzPTOmjjNcX5Qjh6IdIqLu2GdHoYpeyUrkF2VMxXLUteqFUmxNza513m5CcdfAI5zMgz5GQONHVX9oI41XcN3KUushDVsPnqKiVcQUTrKl1CYOm6NnzXILFntfQnmIFy2ts7r1QCq9Mo+dWTIe0FZRcOrAjtHhvtIDD9F6y0qFM1UfLTw1OqzXuP4eqtUdXlUBgbFBmsQLEkm97Ls6oXpU2Y3LU0YnmSoJM6hCvs+z4J9hCV/pBsR67lkKAPRag5e90Uur9YlgbkWOhtrlN9JPExeBBYPYzpiesLoUQ4hkAzZy2IZGYPwAXIbWvfMN1tZhqig2LAHgCRf0my8rm1sDTqYygOrUuPn3cqCwSjcU1vvF6lS+m/IZR27c2zQw1F61Z+wpymwzEsdAgA4nv85UqFSrWpviKuFagjsXyvUyZqa6q+KrMcyUhewpqNddCCZ29BqSFVGVSGweAdtAQ1QioS7c3uAbnXQS14ugHUqfEGytlYbnAYEXB1F4EDhahdLm5OozGmaYe300RjmCa2BO+19Qbyg9MdndXU6xR2am/ufj67/WW7BuBULIM5JyuafzzEAkXr4p8qKFuT1aHS2l90y6T7P62i6gXNsy/aXUeu7zgfOgG1+toGi5u1PQX4od3pul8wFXMuu9dD5bj6WnhXRDaPU4lCT2WORvBtPztPaNnVLPbgw+K6j4FvSRUxERKEREBERAREQEREBKJ012sExCJf2ad/N2P6KJe54j09xJbaVQX0U01HkiE/EmBctiD5rOd7ln+Nh8AJ20V1mrCJloovJFHwE6MMJmFRG1cQBV9pVK2UEvVwzgb+xUZTTranQGw1lgwGzkQhwvbKgO2ilzpdnVAELab7eEqlbHsrN1JV6hJZaa4xwzte+Tqa6FVB4hbW1tJjYW3q9dmSrs+rh2VCwLkFGIIAUOBv15bgZpE/VpK6sjC6sCrDmCLESOHRzDZChpsQXzkl6hctkFM5nzZiMgC2vawtIqpt3Ehuoy0et64Us4ztTH/ACz4kgrmDZgEy7/phvqyxbLxfXUadXLl6ymj232zqGtfjvgdaKAAALAaADkOAlDxvyoYanjRhshNMNkevnGVW3Gy27Sg6FrjjobaynyjbcODwNR0NqlS1KmeIZ73Yd4UMR3gT81wr9fqb6iDPGfk0+UQU1XCYx7ILLRqn6I4U3Pu8m4bjpu9fOLQEA1EBb2QWUE+AvrCNxmMynwiB8mAoqHLhRnIClrC5VSSFJ5Asxt3mZxA58NhEp5slNEzMWbKoXMx3sbbzPuIoq6lHUMp3qwBB46g75XNs7eqU8YlBbWY4bKuQsHFWqyVCz3tTKqLqD7R0F90w2dtvEurtkWqxodfSpoMhvnqJ1eck3uFXtW335iwfekGFAdRlUqVGRWStXAINiEwyAIBbL22beTppr0JcopYMDaxzhVbTS5VSQt99u/hukO2Nx1axxWDTD0xfLavWZi53Bkw+ri19CLSQ2WtkZbKAGJGWhUoCxA4VGJc82+EDy3a1HqcS6jSz3XwJuPznrOHxLvhkqI+V8israGxtY6HTnPN+nlLLiVYfSQHzBt+0vPRGpnwaDlmX9f1mbFjvybQOv8AFfgp/wBED+P/APJ/DT/pkCvSDE6jP+FP2mxduYjjU/Cn7Txc8/2u/GdPS6b3APMXmc80TY7tZ0ruucZ2AYgXfeQBpv8Aymxtk1v/ACn+83EP3/XPqZq/O8cur7T6cno8Sv8ARSq+R0qOXKt2WY3OVtQCeNiDLBPVhlM8ZlPVcrLLqvsRE2hERATwLpk3/udf/wCxf8iT32eA/KAuXalf7dNvWnTMD1G3YXwX8pnR3TXRbNSRuaqfUTbQkhUHsfaivWRBikYknsjHJVJspOiZMzestlTNlbJbNY5c27NbS9uF5VFxTZ1R69RMzZQKmIwqMdbdinTUk+FwfCWqgmVQtybC12JYnxJ3mVFbw2wMQtOmDUpdbTqNVz9sio9SnUp1HqbiCesuLaDKBu3WLZeF6mjTpA5urpol+eRQt7eU4H6RYUBicQllc02IuwV1GZgSoNgoNydw4kSYUwInpR0dpY6kKVa9lYOpBIIYAi+ncTKViPkew59mrUX+ZSPin6z068XgeE9IPksrYem9WnVFRVVnKlbNlUXNiLgnTuk1sLozhxRw5dUfOiM7OocsWUEIhI7KgGw3ezPWXUEEEXBBB8DKLV6FVUOXD4x6dK5KplR8lzcimzaoO7WFSfQzaCBsRguuDmhUtSDPmfqmRHym5zMEZmS/AAAy2TyHaXyYMbV8Him6wEnMWJzOCQzZ17Stmvci+vKbtldP8XgmFHamHdlvlFZQM3nbsvz0IbxhHrExM5NlbWo4lBVw9VaiHip3HkynVT3EAzrMCC2lsI1KxcVsqOcO1RMlyThqhqpke4y3awOh0Glp92PsbqHLGpnAQU0GULlph3ezG5ztd7X00A03zTW6UIudjSqZEGIysChzthmyugW9wc1wCdDlO7S8hszH9cr3plHRyjoSrWYBW0ZdCCrKb98o07fHzRuSO0u561Pj79Dt+W7nIrZJFnsQfZ/xK9Q8d5ra+k6+kNJVGfMwYkD/AK+JpJYA7zSuFPeROXZNUMjEVA4vluuIbEAEDUZmAKnUaHugUn5RE7dI/Vb8xLP0HP8Ayv8AOf8AKsrfT83qUxyVj6n+0s/RJMmG/mY+gA/SZqxXm9onvP5zoSrNJp31BB/vM1pkcvWeHKTbvKlsBiWtqwA1A14Dd+s6xXOnbG/n9n9/jM9n9CBURalSuwLgNlUCwDEEDXjluPG3LWRToNSG+q53ch7uvwb1HLXll8LLK7anmkZ9CWJOIN79pP8AJf8AUS1yO2PsmnhkyUwdTdiTck2AufICSM+h4sOGEx6cMsuWVr7EROjJERATxP5X8JkxqVOD0lP8yMyn4FZ7ZPO/lh2dmw1OuBrTfK32Kmn+cJ6wOnoziOswlNvqW81kjRMp/wAmmOzUnpE6o2YeDf3lwAsZIIbaBak7lcyLfNmzYfD0ix1s9SzVWNzqQv7T5h+mJrV1o4fA16i5wlSqVyIovZmUt7VuRykzu2thiStRFOcdnNTp02qW3jLUq9lFHauSDv079/R/FZ0K3DZSdVd6q6k3HXOAHa975dBoJpFV2tQFOpirUyqFcRSQIhtnqYSgqIoUcShA7xaegYYEIgO8KoPjYT6DPpe2pMg2iCZgrT7KMhKNTq4lkZ0bEOoddBm7Th8QGRW+iuUUbGxTMAG0zEWTbeMemFyaAnUgX14D8534Br01OULcXsBl3m97cL7/ADkGvY2fq/nL5s9X2t+XrHy+WXLbutNmP2fTrKUqU1dSLEEA38Qd8jMbj6q1gqg5bgAWvfdqT6+km7wPOsf8nr0HNfZuIbD1PduSjb+yy66feHdOrZ3Th6LCltOgaD3sKyAtRY7hci5Qn/e0te0NrJRdEcMWdgoyqSFuQuZzuVbkDvvoDIavt/DV0scO7l8mRMqZqiVFd0dczZchRHPaIPZ3XtA4MfsRq7VGoU8qsmJKP1welUeuFIamqk5CxBLHKNTpmuZ1Va+Lw9KpWpYI1Xq4g1GpGoistPq1S5YEgtdBoub2py4LYLU1TEbMxBppUVagpOC1JlcZh82SGQkEaqR4SXwm3xcJiaZoVDoLnNTc8kqaC591grdx3wIZ+kJxCqxo1MMyMVZa71MMb6ao6qUqD6rW8hvlsMGCDMXJNz2yhbuuaYCkcjy3yOaq9SqwDsrEjMEYo6pey9bha+ZGW2hdDdrad0uygWUAAAWAGgAHAAbtJRSukWBNSvn+ioVfTU/nLLsrDn+HppuLgC/Iud/lmmO1sN2Av0nYIP5jqfIXPlJnZdLNWQDcoLeSjKPiw9Jmq4k+T+mP/k1fwf0zZ/6Dpca9X8H9Mt8TPDHpd1hTphVCjcAAPAC02RE2hERAREQEREBODbWzlxFCrQbQVEZb8iRo3iDY+U74gfnvoxi2wuMCuMvaNKoORvb4MJ7DUpdnMP8AQlC+VbYPV1lxSL2KvZe3CoBof5lHqp5yx9A9tDE0Ajn5ymArd6/Rb/XKBKVKSujI6qysLFWAZSOTKdCO6V6orpUy53NQgqpGQ1HQHXqKY+bw1LcM7DMRa+tjLPWp5D3cJw7UwIqoQFDE2uhbKlS25apUFmQXJy7juNwZUd+BdOrTq3zoAArZzUuBpcuSSx03km8hulCK7YVHUOjYgh0YAq1sPXYBlOhswVrHiAZAbYqYtqTUsNVdajkMhIKu4UgM6KTbDUFACrpdiRzu3b0M6PN/CsMbTz1KzmrVWoQ4LX7JKnsqbAbuQ14AJ/olUZsFhmYkk0KJJJuSci6k8TJkTXTUAAAAAAAAaAAcAOEzvAzIn28wvF4GRn28wvPt4Edt6gzogRSSK1FjbgquCT4AXMqWztl4in1Dth3PUJhaTICmZjSo16bugLWK5qqWJIuL6aS+kz5eBHdHsM1LC4ek1s1OlTRrG4Doiqwv3EGRPSJUd2AJzBLVgPnFCN7HXYc+3TPa7a6i2+17cX/CK2Br1KuHqE4WrneshBqNSqN/i0l3uLkFlvewO/Sb8LhzUcFtynOGDOQpftCphawvem9u1TJ08LZg2bDwoVM97p/hgOKqKCPboVCM6owNst7DLoLamYw1O+swCZjYTox1YUkJtc+yo95joBIqKxLB63dTH42H6L/mk70fo9lqh+kbL9lbj4kt6CQGEwrErTBu7k5m7zq7+QvbwAl0pUwqhVFgAAB3CQbYiJQiIgIiICIiAiIgIiIHDtfZqYii1GoLq4t3gjUMO8EA+U8n2VsrEYPEPlW70vaG4Oh5dzDUciPGezSN2lgc9nUDOosOGZd+Un4g8D4mByYPFJiKauhuG9VI3qRwIOk0spU2MiWR8O5r0VLIx+epbiSNC6Dg44jjaT+HrJXQOjBlO4jgeR5EcoHGlFAzOFAZrZjxOUWAJ5DX1M6FM11KRU67ucK0qOhZkJpVpsDQM4mOaM0DOJhmjNA+kzFnmt3mp3gZu85KdIKMqKALk2AsLkkk2HeSZtVSxsBO6jQCC5PiTwgY0qQRSSe8nlIHEYrrH6w6IoOQHTTi55X4d3jM9oY3rjlXSkPxn+j8/Df17FwHWkVGHzam6j32H0vsg+p7hrlUhsHBFQarizuNAd6pvAPInQnyHCTURKEREBERAREQEREBERAREQERECOxuCzdpLBuIO5rcDyPf+crb4V6btUw3Ye/zlJtFf7Q+i3Jhv7xLrOTF4NX7mG5hvHd3juOkCJ2btenXuhBSoPapvow7x7y94nRVwfFfSRm1dkgj51L5dVqJcFTzuO0h793fOajj8TQte2Jp8DcK4Hj7L/CBJspXeIDzHCdIsNUOU1Mj+5UHVm/IZtD5EySOGRtR6iE04Q8Zp0nBDgZicD9aU00ZpiXnUMCPeM2rhFHC/jAjtTuF5vpYInVtO6ZYnadClozrm91e033VuZF4nbjvpTTIPeexbyQaDzPlJtUvicTTordjbgANSx5KN5Mr+PxzVdX7CDXJff3ueP2d3O856Ks7kIrVam5m32+0x0Qcbadwli2bsBVIesQ7jUD6CnmAfaPefICQcOy9kNWs1QFae8KdC/j7qd289w32lFAFgLAaATOJQiIgIiICIiAiIgIiICIiAiIgIiICIiAkdidlo1yt0Y7ylhc82U6HxtfvkjECp7Q6PuwIKJVHdZW+63Z/EJX6uyGo6oa9H7OcKPMXT4z0yIHly7WxSaLjA/2gjfpebF6Q43/ALifcE9HqUFb2kVvFQfzmk7Lof8AYp/cT9oFDG2sQ3tYnL9lUH5gwHapvqVavcC7j7qafCX9MDSX2aSDwRR+QnQBJoUbCbGrtotAIvNyqD7q3b1AkxhejK761Qv9VewvnY5j6gd0sURoaaNBUUKihVG4KAAPITdEShERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERA//9k=";

  @override
  void initState() {
    super.initState();
    setState(() {
      data = widget.data.toJson();
      for (final qrKey in excludeQrData) {
        if (qrKey.contains('Date')) {
          modData[qrKey] = DateTime.fromMillisecondsSinceEpoch(data[qrKey]);
        } else {
          modData[qrKey] = data[qrKey];
        }
      }
    });
    init();
  }

  init() async {
    final date = DateTime.now();
    //convert timestamp String to DateTime
    final dueCalibTime =
        DateTime.fromMillisecondsSinceEpoch(data['nextCalibrationDate']);
    final dueMsaTime = DateTime.fromMillisecondsSinceEpoch(data['nextMsaDate']);

    //calculate current date minus data.nextCalibrationDate
    dueCalibDate = date.difference(dueCalibTime).inDays.toString();

    //calculate current date minus data.nextMsaDate
    dueMsaDate = date.difference(dueMsaTime).inDays.toString();

    //decode base64 string to Image file
    // final decodedImage = base64Decode(data['gaugeProfile']);
    // print(decodedImage);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget _titleOtherDetails() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
        child: Text(
          'Other Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gauge Profile"),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
          ),
        ),
      ),
      body: Column(
        children: [
          Image.memory(base64Decode(image), fit: BoxFit.cover).expand(),
          Card(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Row(
                children: [
                  Expanded(
                      child: SizedBox(
                          child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(30),
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 10,
                    childAspectRatio: 4,
                    children: <Widget>[
                      Text(
                        "Gauge Status: ${data['gaugeStatus']}",
                        style: data['guageStatus'] == 'ACTIVE'
                            ? boldTextStyle(color: Colors.green)
                            : boldTextStyle(color: Colors.red),
                      ),
                      Text(
                        "Gauge Type: ${data['gaugeType']}",
                        style: boldTextStyle(color: Colors.black),
                      ),
                      Text(
                        "Calib Due In(Days): $dueCalibDate",
                        style: boldTextStyle(color: Colors.black),
                      ),
                      Text(
                        "Msa Due In(Days): $dueMsaDate",
                        style: boldTextStyle(color: Colors.black),
                      ),
                    ],
                  )))
                ],
              )),
          Expanded(
              child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        borderOnForeground: true,
                        child: ListTile(
                          // tileColor: Colors.white54,
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(5)),
                          title: Text(modData.keys.elementAt(index)),
                          trailing:
                              Text(modData.values.elementAt(index).toString()),
                        ),
                      );
                    },
                    itemCount: modData.length,
                  )))
        ],
      ),
    );
  }
}
