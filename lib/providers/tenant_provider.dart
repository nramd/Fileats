import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/tenant_model.dart';
import '../data/models/menu_item_model.dart';
import '../core/constants/app_constants.dart';

class TenantProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore. instance;

  List<TenantModel> _tenants = [];
  TenantModel? _selectedTenant;
  List<MenuItemModel> _menuItems = [];
  bool _isLoading = false;
  String?  _errorMessage;

  List<TenantModel> get tenants => _tenants;
  TenantModel? get selectedTenant => _selectedTenant;
  List<MenuItemModel> get menuItems => _menuItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<TenantModel> get openTenants => _tenants.where((t) => t.isOpen).toList();

  Future<void> fetchTenants() async {
    try {
      _isLoading = true;
      notifyListeners();

      final snapshot = await _firestore. collection(AppConstants.tenantsCollection).get();
      _tenants = snapshot.docs. map((d) => TenantModel.fromFirestore(d)).toList();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchMenuItems(String tenantId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final snapshot = await _firestore
          .collection(AppConstants.menuItemsCollection)
          .where('tenantId', isEqualTo: tenantId)
          .get();

      _menuItems = snapshot.docs.map((d) => MenuItemModel.fromFirestore(d)).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void selectTenant(TenantModel tenant) {
    _selectedTenant = tenant;
    notifyListeners();
    fetchMenuItems(tenant.id);
  }

  Future<void> toggleTenantStatus(String tenantId, bool isOpen) async {
    try {
      await _firestore.collection(AppConstants.tenantsCollection).doc(tenantId).update({
        'isOpen': isOpen,
      });

      final index = _tenants.indexWhere((t) => t.id == tenantId);
      if (index != -1) {
        _tenants[index] = _tenants[index].copyWith(isOpen: isOpen);
        if (_selectedTenant?. id == tenantId) {
          _selectedTenant = _selectedTenant! .copyWith(isOpen: isOpen);
        }
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  List<MenuItemModel> getMenuByCategory(String category) {
    if (category == 'Semua') return _menuItems;
    return _menuItems.where((m) => m.category == category).toList();
  }

  List<String> get categories {
    final cats = _menuItems.map((m) => m.category).toSet().toList();
    return ['Semua', ...cats];
  }
}