import 'package:cinema_app/presentation/blocs/authentication/auth_bloc.dart';
import 'package:cinema_app/presentation/blocs/authentication/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OTPInput extends StatelessWidget {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 85,
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: _buildTextField(context, _controller1, true, false),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 85,
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: _buildTextField(context, _controller2, false, false),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 85,
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: _buildTextField(context, _controller3, false, false),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 85,
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: _buildTextField(context, _controller4, false, true),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 22,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>()
                      ..otp = '${_controller1.text}${_controller2.text}${_controller3.text}${_controller4.text}'
                      ..add(AuthEvent.authenticate);
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Text(
                      'Підтвердити',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(BuildContext context, TextEditingController controller, bool first, bool last) {
    return TextField(
      controller: controller,
      autofocus: true,
      onChanged: (value) {
        if (value.length == 1 && !last) {
          FocusScope.of(context).nextFocus();
        }
        if (value.length == 0 && !first) {
          FocusScope.of(context).previousFocus();
        }
      },
      showCursor: false,
      readOnly: false,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      keyboardType: TextInputType.number,
      maxLength: 1,
      decoration: InputDecoration(
        counter: const Offstage(),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.black12),
            borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.purple),
            borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

