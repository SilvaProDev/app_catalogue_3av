
import '../model/carousel_slider.dart';


List<CarouselSilderModel> getCarouselSlider() {
  List<CarouselSilderModel> slider = [];
  CarouselSilderModel silderModel = new CarouselSilderModel();

  silderModel.image = 'images/business.jpg';
  silderModel.name = 'Session ordinaire le 30/05/2025 ';
  silderModel.description = 'Le Secrétariat Général de la Mutuelle des Agents du Contrôle Financier (MUCAF) informe ...(voir plus) ';
  slider.add(silderModel);
  silderModel = new CarouselSilderModel();

  silderModel.image = 'images/entertainment.jpg';
  silderModel.name = 'Detente Music ';
  silderModel.description = "Le jeudi 21 mars, nous avons eu le privilège d'accueillir le Président de la MUCAF -Mutuelle des Agents du Contrôle Financier";
  slider.add(silderModel);
  silderModel = new CarouselSilderModel();

  silderModel.image = 'images/health.jpg';
  silderModel.name = 'La randonnée du MUCAF';
  silderModel.description = 'Tous les mutualistes et agents de la MUCAF sont invités Le Directeur du Contrôle Financier à prendre part';
  slider.add(silderModel);
  silderModel = new CarouselSilderModel();


  return slider;
}
