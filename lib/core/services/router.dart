import 'package:firebase_auth/firebase_auth.dart';
import 'package:fivoza_learning/core/common/pages/page_under_construction.dart';
import 'package:fivoza_learning/core/extensions/context_extensions.dart';
import 'package:fivoza_learning/core/services/injection_container.dart';
import 'package:fivoza_learning/features/auth/data/models/user_model.dart';
import 'package:fivoza_learning/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fivoza_learning/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:fivoza_learning/features/auth/presentation/pages/sign_in_screen.dart';
import 'package:fivoza_learning/features/auth/presentation/pages/sign_up_screen.dart';
import 'package:fivoza_learning/features/dashboard/presentation/pages/dashboard.dart';
import 'package:fivoza_learning/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:fivoza_learning/features/onboarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:fivoza_learning/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'router.main.dart';
