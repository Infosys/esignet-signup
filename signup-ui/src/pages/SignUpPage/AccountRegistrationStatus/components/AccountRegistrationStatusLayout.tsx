import { useTranslation } from "react-i18next";
import { useLocation } from "react-router-dom";

import { ReactComponent as FailedIconSvg } from "~assets/svg/failed-icon.svg";
import { ReactComponent as SuccessIconSvg } from "~assets/svg/success-icon.svg";
import { ReactComponent as WarningIconSvg } from "~assets/svg/warning-icon.svg";
import { Button } from "~components/ui/button";
import { Step, StepContent } from "~components/ui/step";
import { getSignInRedirectURL } from "~utils/link";
import { useSettings } from "~pages/shared/queries";

interface AccountRegistrationStatusLayoutProps {
  status: "success" | "warning" | "failed";
  message: string;
}

export const AccountRegistrationStatusLayout = ({
  status,
  message,
}: AccountRegistrationStatusLayoutProps) => {
  const { t } = useTranslation();
  const { data: settings } = useSettings();
  const { hash: fromSignInHash } = useLocation();

  const handleAction = (e: any) => {
    e.preventDefault();
    window.location.href = getSignInRedirectURL(
      settings?.response.configs["signin.redirect-url"],
      fromSignInHash,
      "/signup"
    );
  };

  return (
    <Step>
      <StepContent>
        <div className="flex flex-col items-center gap-4 py-4">
          {status === "success" ? (
            <SuccessIconSvg />
          ) : status === "warning" ? (
            <WarningIconSvg />
          ) : (
            <FailedIconSvg />
          )}
          <div className="text-center text-lg font-semibold">
            {status === "success" ? (
              <>
                <h1>{t("congratulations")}</h1>
                <h2>{t("account_created_successfully")}</h2>
              </>
            ) : (
              <h1>
                {status === "warning"
                  ? t("signup_pending")
                  : t("signup_failed")}
              </h1>
            )}
          </div>
          <p className="text-center text-gray-500">{message}</p>
        </div>
        <Button
          id="success-continue-button"
          className="my-4 h-16 w-full"
          onClick={handleAction}
        >
          {fromSignInHash ? t("login") : t("okay")}
        </Button>
      </StepContent>
    </Step>
  );
};
