import { SizeValue } from "../constants/types";

interface ILoadingIndicator {
    message?: string;
    size?: SizeValue;
    msgParam?: string;
    i18nKeyPrefix?: string;
    iconClass?: string;
}

export default ILoadingIndicator;