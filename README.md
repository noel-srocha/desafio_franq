# FakeStore Explorer (desafio_franq)

Aplicativo Flutter para explorar produtos da Fake Store API, com lista, detalhes, busca, filtro por categoria, favoritos com persistência local, autenticação básica, tema claro/escuro, paginação incremental e suporte a cache offline.

## Sumário
- [Arquitetura e Decisões Técnicas](#arquitetura-e-decisões-técnicas)
- [Funcionalidades](#funcionalidades)
- [Requisitos Atendidos](#requisitos-atendidos)
- [Como Rodar](#como-rodar)
- [Estrutura de Pastas](#estrutura-de-pastas)
- [Testes](#testes)
- [Credenciais de Exemplo](#credenciais-de-exemplo)

## Arquitetura e Decisões Técnicas
- Clean Architecture em camadas: `domain`, `data`, `presentation` (UI), `core` (infra comum).
- Gerência de estado: `bloc`/`cubit` (pacote `flutter_bloc`).
- Rede: `dio` com `BaseOptions` centralizados em `core/network/dio_client.dart`.
- Persistência local: `hive` (cache de produtos e IDs de favoritos) + `shared_preferences` (token e tema).
- Modelagem de entidades (`domain/entities`) separada de modelos de dados (`data/models`).
- Paralelismo: carregamento de produtos e categorias com `Future.wait`.
- Paginação: incremento local via `loadMore()` no `ProductListCubit` (page size = 10).
- Offline-first: fallback para cache quando a chamada remota falha.
- Tratamento de erros: mensagens amigáveis e SnackBars/avisos na UI.
- Boas práticas: SOLID, responsabilidades separadas, imutabilidade de estados com `equatable`.

## Funcionalidades
- Listagem de produtos (imagem, nome e preço).
- Detalhes do produto (descrição, categoria, rating, preço) com animação Hero.
- Busca por nome (debounce) e filtro por categoria.
- Favoritar/Desfavoritar com animação e persistência local.
- Autenticação básica usando endpoint `/auth/login` da Fake Store (armazena token localmente).
- Tema claro/escuro com persistência.
- Paginação incremental (carrega mais ao rolar).
- Cache local e exibição offline quando a rede falha.

## Requisitos Atendidos
- Nível 1: lista com dados da API, item com imagem/nome/preço, tela de detalhes.
- Nível 2: busca, filtro por categoria, favoritos com persistência local, autenticação básica, clean code, aba de favoritos.
- Nível 3: operações paralelas (`Future.wait`), gerenciador de estado (Bloc/Cubit), pelo menos 1 teste unitário (filtro), diferenciais: tema escuro, animações sutis, paginação incremental, offline com cache, feedback de erros.

## Como Rodar
Pré-requisitos:
- Flutter SDK (Dart >= 3.9.0 conforme `pubspec.yaml`).
- Dispositivo/emulador configurado.

Passos:
1. Instale dependências:
   ```bash
   flutter pub get
   ```
2. Rode o app:
   ```bash
   flutter run
   ```
3. (Opcional) Rode os testes:
   ```bash
   flutter test
   ```

## Estrutura de Pastas
- `core/`: constantes, rede (Dio), erros/exceptions.
- `domain/`: entidades e contratos (repositórios) + casos de uso.
- `data/`: datasources (remoto/local) e repositórios (implementações).
- `presentation/`: páginas, widgets, Cubits/Blocs e estados (auth, produtos, favoritos, tema) e utilitários (formatação de moeda).

## Testes
- `test/filter_products_test.dart`: valida a lógica de busca e filtro por categoria.

## Credenciais de Exemplo
A Fake Store API fornece usuários de exemplo. Um par funcional:
- usuário: `mor_2314`
- senha: `83r5^_`

Essas credenciais já vêm preenchidas na tela de Login para conveniência.
