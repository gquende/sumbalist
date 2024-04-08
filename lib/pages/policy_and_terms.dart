import 'package:flutter/material.dart';

class PolicyAndTerms extends StatelessWidget {
  const PolicyAndTerms({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Políticas e Termos de uso"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Text(
              "A sua privacidade é importante para nós. É política do nosso aplicativo respeitar a sua privacidade em relação a qualquer informação que possamos coletar durante a sua utilização do aplicativo. Solicitamos informações pessoais apenas quando realmente necessárias para fornecer os nossos serviços As informações pessoais que coletamos são utilizadas para melhorar a experiência do usuário e garantir a segurança dos dados. Não compartilhamos suas informações pessoais com terceiros. "
              "Ao utilizar o nosso aplicativo, você concorda com a coleta e uso de informações de acordo com esta política de privacidade.Termos de UsoAo utilizar o nosso aplicativo, você concorda em cumprir os seguintes termos:Você é responsável por manter a segurança de sua conta e senha. Não compartilhe suas credenciais de login com terceiros.Não utilize o aplicativo para atividades ilegais ou que violem os direitos de terceiros.Respeite os direitos de propriedade intelectual do aplicativo, incluindo marcas registradas, direitos autorais e patentes."
              "O aplicativo pode utilizar cookies para melhorar a experiência do usuário. "
              "Ao utilizar o aplicativo, você concorda com o uso de cookies de acordo com a nossa política de cookies.O aplicativo pode coletar informações não pessoais, como dados de uso e análises, para melhorar os serviços oferecidos.Reservamo-nos o direito de suspender ou encerrar sua conta caso haja violação destes termos de uso.Ao utilizar o aplicativo, você concorda em cumprir estes termos de uso e nossa política de privacidade. Se tiver alguma dúvida ou preocupação, entre em contato conosco através dos canais de suporte fornecidos no aplicativo."),
        ),
      ),
    );
  }
}
