import '../../../CommonFiles/Model/meta_model.dart';

class CategoryTreeModel {
  String? message;
  List<CategooryTreeData>? data;
  Meta? meta;

  CategoryTreeModel({this.message, this.data, this.meta});

  CategoryTreeModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <CategooryTreeData>[];
      json['data'].forEach((v) {
        data!.add(new CategooryTreeData.fromJson(v));
      });
    }
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class CategooryTreeData {
  String? id;
  String? name;
  String? slug;
  String? image;
  String? imageUrl;
  List<TreeSubcategories>? subcategories;

  CategooryTreeData(
      {this.id,
        this.name,
        this.slug,
        this.image,
        this.imageUrl,
        this.subcategories});

  CategooryTreeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
    imageUrl = json['image_url'];
    if (json['subcategories'] != null) {
      subcategories = <TreeSubcategories>[];
      json['subcategories'].forEach((v) {
        subcategories!.add(new TreeSubcategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['image'] = this.image;
    data['image_url'] = this.imageUrl;
    if (this.subcategories != null) {
      data['subcategories'] =
          this.subcategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TreeSubcategories {
  String? id;
  String? name;
  String? slug;
  String? image;
  String? imageUrl;
  List<ProductCategories>? productCategories;

  TreeSubcategories(
      {this.id,
        this.name,
        this.slug,
        this.image,
        this.imageUrl,
        this.productCategories});

  TreeSubcategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
    imageUrl = json['image_url'];
    if (json['productCategories'] != null) {
      productCategories = <ProductCategories>[];
      json['productCategories'].forEach((v) {
        productCategories!.add(new ProductCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['image'] = this.image;
    data['image_url'] = this.imageUrl;
    if (this.productCategories != null) {
      data['productCategories'] =
          this.productCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductCategories {
  String? id;
  String? name;
  String? slug;
  String? image;
  String? imageUrl;

  ProductCategories({this.id, this.name, this.slug, this.image, this.imageUrl});

  ProductCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['image'] = this.image;
    data['image_url'] = this.imageUrl;
    return data;
  }
}

