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
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                textWithTitle(
                    "",
                    "A sua privacidade é importante para nós. É política do nosso aplicativo respeitar a sua privacidade em relação a qualquer informação que possamos coletar durante a sua utilização do aplicativo. ",
                    context),
                textWithTitle(
                    "1. Coleta de Informações",
                    "A Sumbalist coleta algumas informações pessoais no intuito de melhorar a experiência do usuário, de igual modo garantimos a segurança dos mesmos A aplicação coleta as seguintes informações: Informações de Registro: Ao se registrar na aplicação, solicitamos seu nome, senha, emaill e número de telefone. Informações de Compra: Quando você adiciona itens à sua lista de compras, coletamos informações sobre os itens e suas preferências de compra. Informações de Uso: Podemos coletar informações sobre como você usa nossa aplicação, incluindo interações com os recursos e o tempo gasto em determinadas páginas",
                    context),
                textWithTitle(
                    "2. Uso das Informações",
                    "Usamos as informações coletadas para: Facilitar a funcionalidade da lista de compras. personalizar sua experiência com base em suas preferências, melhorar e otimizar nossa aplicação, comunicar atualizações, ofertas e novidades sobre a aplicação",
                    context),
                textWithTitle(
                    "3. Compartilhamento de Informações",
                    "Não compartilhamos suas informações pessoais com terceiros, exceto quando necessário para fornecer os serviços solicitados por você ou quando exigido por lei.",
                    context),
                textWithTitle(
                    "4. Segurança das Informações",
                    "Implementamos medidas de segurança para proteger suas informações contra acesso não autorizado, alteração, divulgação ou destruição não autorizada.",
                    context),
                textWithTitle(
                    "5. Alterações na Política de Privacidade",
                    "Podemos atualizar esta Política de Privacidade periodicamente. Notificaremos você sobre quaisquer alterações significativas enviando um aviso para o endereço de e-mail fornecido ou publicando uma versão atualizada em nosso site.",
                    context),
                Text(
                  "Termos de uso",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                    "Ao usar nossa aplicação de lista de compras, você concorda em cumprir estes Termos de Uso."),
                SizedBox(
                  height: 10,
                ),
                textWithTitle(
                    "1. Uso da Aplicação",
                    "Você concorda em usar a aplicação apenas para fins legais e de acordo com estes Termos de Uso. Você não pode usar a aplicação de forma que possa danificar, desativar, sobrecarregar ou prejudicar a aplicação.",
                    context),
                textWithTitle(
                    "2. Conta do Usuário",
                    "Você é responsável por manter a segurança de sua conta de usuário e senha. Não compartilhe suas credenciais de login com terceiros.",
                    context),
                textWithTitle(
                    "3. Limitação de Responsabilidade",
                    "Em nenhuma circunstância seremos responsáveis por quaisquer danos diretos, indiretos, incidentais, especiais, consequenciais ou punitivos decorrentes do uso ou incapacidade de usar nossa aplicação.",
                    context),
              ],
            ),
          )),
        ));
  }

  Widget textWithTitle(String title, String text, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          text,
          textAlign: TextAlign.justify,
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
