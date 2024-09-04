/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */
package io.mosip.signup.validator;

import org.springframework.beans.factory.annotation.Value;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.util.List;

public class LanguageValidator implements ConstraintValidator<Language, String> {


    @Value("#{${mosip.signup.supported-languages}}")
    private List<String> supportedLanguages;

    private boolean required;

    @Override
    public void initialize(Language constraintAnnotation) {
        this.required = constraintAnnotation.required();
    }

    @Override
    public boolean isValid(String value, ConstraintValidatorContext constraintValidatorContext) {
        if(value == null)
            return !this.required;

        return supportedLanguages.contains(value);
    }
}
